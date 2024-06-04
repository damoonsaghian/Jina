local path = require"pl.path"
local dir = require"pl.dir"
local utils = require"pl.utils"
require"pl.stringx".import()

function import(module_name)
	local old_package_path = package.path
	package.path = path.join(path.dirname(debug.getinfo(1, "S").short_src), "?.lua")
	require(module_name)
	package.path = old_package_path
end

local generate_t_file = import"generate_t_file"
local generate_c_file = import"generate_c_file"

if arg[1] == nil then
	print"interactive Jina is not yet implemented"
	print"to compile a project: jina <project_path> [gcc_options]"
	os.exit()
end
if arg[1]:char(1) == "-" then
	print"usage: jina <project_path> [gcc_options]"
	os.exit()
end

if not path.isdir(arg[1]) then
	print('directory "'..arg[1]..'" does not exists')
	os.exit(false)
end

local pkg_id_list = {}
local pkg_table = {}
-- { pkg_id = { path = "project_path/package_name.jin", dlibs = "-la -lb ", upm = "a,b," }, dep_out_paths = {} }
-- pkg_id is "package_name_url_hash", where the "url_hash" part is only for dependency packages

-- find all directories named "*.jin" inside arg[1] directory, and add them to pkg_id_list and pkg_table
for _, dir_path in ipairs(dir.filter(dir.getdirectories(arg[1]), "*.jin")) do
	local dir_name = path.basename(pkg_path:rstrip".jin")
	table.insert(pkg_id_list, dir_name)
	pkg_table[dir_name] = { path = dir_path, dlibs = "", upm = "", dep_out_paths = {} }
end

--[[
for each pkg_id in pkg_id_list, go through all files in pkg_table[pkg_id].path (recursively) and:
, from .jin files generate .t files
, for each ".p" file, download the package (if needed), and add it to pkg_id_list and pkg_table
]]
local i = 1
while pkg_id_list[i] do
	local pkg_id = pkg_id_list[i]

	local pkg = pkg_table[pkg_id]
	local project_path = path.dirname(src.path)
	
	dir.getallfiles(pkg.path):foreach(function (file_path)
		if file_path:find"%.jin$" then
			generate_t_file(project_path, file_path)
		elseif file_path:find"%.p$" then
			local file = io.open(file_path)
			local dep_pkg_name = file:read()
			local url = file:read()
			local public_key = file:read()
			file:close()
			
			local dep_pkg_id, dep_pkg_path
			if url then
				local url_protocol = url:split"://"
				local _, _, url_hash = utils.executeex('echo -n ' .. url .. ' | md5sum | cut -d " " -f1')
				-- download the url to ~/.local/share/jina/packages/url_hash/
				
				if public_key then
					-- use the public key to check the signature ("dep_project_path/.data/sig")
					-- if invalid, notice the user, then os.exit(false)
				end
				
				dep_pkg_id = dep_pkg_name .. "_" .. url_hash
				dep_pkg_path = path.join(path.expanduser"~/.local/share/jina/packages", url_hash, dep_pkg_name)
			else
				-- if there is no entry in the .p file
				dep_pkg_id = dep_pkg_name
				dep_pkg_path = path.join(project_path, dep_pkg_name)
			end
			
			table.insert(
				pkg.dep_paths,
				path.join(path.dirname(dep_pkg_path), ".cache", "jina", "out", dep_pkg_name)
			)
			
			if
				not pkg_table[dep_pkg_id] or
				require"pl.tablex".find(pkg_id_list, dep_pkg_id) < i
			then
				pkg.dlibs = pkg.dlibs .. "-l" .. dep_pkg_id .. " "
				table.insert(pkg_id_list, dep_pkg_id)
				pkg_table[dep_pkg_id] = { path = dep_pkg_path, dlibs = "", upm = "", dep_out_paths = {} }
			end
		end
	end)
	i = i + 1
end

local upm_packages = ""

-- recursively go through all files in all packages in pkg_table
-- generate .c and .h files from .jin and .t files
for pkg_id, pkg in pairs(pkg_table) do
	dir.getallfiles(pkg.path):foreach(function (file_path)
		if file_path:find"%.jin$" then
			generate_c_file(pkg, pkg_id, file_path)
		end
	end)
	
	upm_packages = upm_packages .. pkg.upm .. " "
end

--[[
TODO: use multiple threads to generate .t and c files
number of spawn threads will be equal to the number of CPU cores,
	or the number of Jina files, either one which is smaller
https://lualanes.github.io/lanes/
]]

local _, _, project_path_hash = utils.executeex('echo -n ' .. arg[1] .. ' | md5sum | cut -d " " -f1')

os.execute("upm" .. " add jina-"..project_path_hash .. " " .. upm_packages)

local process_handles = {}

-- go through all files in all ".cache/jina/c/package_name" directories of all packages in pkg_table
-- compile C files to object files
for _, pkg in pairs(pkg_table) do
	local project_path, pkg_name = path.splitpath(pkg.path)
	local c_dir_path = path.join(project_path, ".cache/jina/c", pkg_name)
	local o_dir_path = path.join(project_path, ".cache/jina/o", pkg_name)
	
	for _, c_file_path in ipairs(dir.getfiles(c_dir_path)) do
		local file_name = path.splitext(path.basename(c_file_path))
		
		-- if for the C file, there is no corresponding jina file, delete it and its .h and .o file
		local jin_file_path = path.join(project_path, file_name:replace("__", path.sep) .. ".jin")
		if not path.isfile(jin_file_path) then
			os.remove(c_file_path)
			os.remove(path.join(project_path, ".cache/jina/h", pkg_name, file_name..".h"))
			os.remove(path.join(o_dir_path, file_name..".o"))
			goto skip
		end
		
		local o_file_path = path.join(o_dir_path, file_name..".o")
		local o_file_mtime = path.getmtime(o_file_path)
		
		local c_file_mtime = path.getmtime(c_file_path)
		
		if
			not c_file_mtime or not o_file_mtim or
			c_file_mtime > o_file_mtime or
			o_file_mtime > os.time() -- o_file is from future!
		then
			dir.makepath(o_dir_path)
			if path.isfile(path.join(pkg.path, "0.jin")) then
				local handle = io.popen(
					"gcc -Wall -Wextra -Wpedantic -c " .. c_file_path .. " -o " .. o_file_path,
					"r"
				)
				table.insert(process_handles, handle)
			else
				local handle = io.popen(
					"gcc -Wall -Wextra -Wpedantic -fPIC -c " .. c_file_path .. " -o " .. o_file_path,
					"r"
				)
				table.insert(process_handles, handle)
			end
		end
		
		::skip::
	end
end

-- wait for all process to complete
for _, handle in ipairs(process_handles) do
	handle:read"a"
	handle:close()
end

local gcc_options = ""
for i = 2, #arg, 1 do
	gcc_options = gcc_options .. arg[i] .. " "
end

-- go through all files in all ".cache/jina/o/package_name" directories of all packages in pkg_table
-- link object files
-- iteration is done backward from the end, to create dependecies before dependants
for i = #pkg_id_list, 1, -1 do
	local pkg_id = pkg_id_list[i]
	local pkg = pkg_table[pkg_id]
	local project_path, pkg_name = path.splitpath(pkg.path)
	local o_dir_path = path.join(project_path, ".cache/jina/o", pkg_name)
	local out_path = path.join(project_path, ".cache/jina/out", pkg_name)
	
	if pkg.needs_compile then
		path.isdir(out_path) and dir.rmtree(out_path)
	end
	dir.makepath(out_path)
	
	if package_name ~= "std" then
		os.execute("ln -f " .. path.expanduser("~/.local/apps/jina/libstd.jin.so") .. " " .. out_path)
		pkg.dlib = pkg.dlib .. "-lstd.jin "
	end
	
	-- hardlink .so files of dependencies into "out" directory
	for _, dep_out_path in ipairs(pkg.dep_out_paths) do
		os.execute("ln -f " .. dep_out_path .. "/* " .. out_path)
	end
	
	-- if compilation result exists already, goto skip
	if 
		path.isfile(path.join(out_path, "lib" .. pkg_id .. ".jin.so")) or
		path.isfile(path.join(out_path, pkgname))
	then
		goto skip
	end
	
	if path.isfile(path.join(pkg.path, "0.jin")) then
		local out_executable_path = path.join(out_path, pkg_name)
		os.execute(
			"gcc -Wl,-rpath-link=. -L. " .. gcc_options .. o_dir_path.."/*.o " .. pkg.dlibs ..
			" -o " .. out_executable_path
		) or os.exit(false)
		os.execute("LD_LIBRARY_PATH=. " .. out_executable_path)
	else
		local out_lib_path = path.join(out_path, "lib" .. pkg_id .. ".jin.so")
		os.execute(
			"gcc -shared -Wl,-rpath-link=. -L. " .. gcc_options .. o_dir_path.."/*.o " .. pkg.dlibs ..
			" -o " .. out_lib_path
		) or os.exit(false)
	end
	
	::skip::
end
