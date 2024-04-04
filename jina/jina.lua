local path = require"pl/path"
local dir = require"pl/dir"
require"pl.stringx".import()

local generate_t_file = require"generate_t_file"
local generate_c_file = require"generate_c_file"

if os.execute("command -v ospkg-deb 1>/dev/null") then
	ospkg_type = "deb"
end

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
	error("there is no directory at \""..arg[1].."\"\n")
end

local package_names_list = {}
local packages_table = {}
-- { package_name = package }
-- each package has these fields: path, deps (list of dep paths), dlibs, ospkg
-- find all directories named "*.jin" inside arg[1] directory, and add them to packages

--[[
for each package in packages_table, go through all files in package.path (recursively) and:
, from .jin files generate .t files
, for each "package_name.p" file, if it's not a "lib://" protocol package:
	download the package (if needed)
	inside the download, the directory with the name "package_name" contains the source of the package
	add it to root_paths
]]
local i = 1
while package_names_list[i] do
	local package = packages_table[package_names_list[i]]
	local project_path = path.dirname(package.path)
	local package_name = path.basename(package.path)
	
	local out_path = project_path .. "/.cache/jina/out/" .. package_name
	dir.makepath(out_path)
	
	dir.getallfiles(package.path):foreach(function (file_path)
		if file_path:find"%.jin$" then
			generate_t_file(project_path, file_path)
		elseif file_path:find"%.p$" then
			if package_table[package_name] then
				table.insert(package_names_list, package_name)
				return
			end
			
			local url, key
			local url_is_available = false
			for line in io.lines(file_path) do
				-- if gnunet or git is needed to add a package, and they are not installed on the system,
				-- ask the user to install them first, then exit with error
				-- dep_package will be downloaded to ~/.local/share/jina/packages/url_hash/dep_package_name
				if line_is_a_url then
					if url_is_available then break end
					url =
					key = nil
					-- test if url is available, url_is_available = true
				else
					key =
				end
			end
			
			-- if url protocol is lib:// and the lib exists on the system,
			-- just hard link it from system to out directory, and return
			--os.execute("ln /usr/lib/*/libpackage_name.jin.so "..out_path.."/")
			
			local url_hash
			local dep_package = {
				path = path.join(path.expanduser"~/.local/share/jina/packages", url_hash, dep_name)
			}
			local dep_name = path.basename(deb_package.path)
			
			-- if there is no entry in the .p file
			if not url then
				dep_package.path = path.join(project_path, package_name)
			end
			
			if not path.isdir(dep_package.path) then
				error('package:\n\t' .. package.path .. '\nneeds package:\n' .. dep_package.path ..
					"\nwhich does not exists")
			end
			
			package.dlibs = package.dlibs .. "-l" .. dep_package_name .. ".jin "
			
			packages_table.package_name = dep_package
		end
	end)
	i = i + 1
end

-- recursively go through all files in all packages in packages_table
-- generate .c and .h files from .jin and .t files
for _, package in pairs(packages_table) do
	dir.getallfiles(package.path):foreach(function (file_path)
		if file_path:find"%.jin$" then
			generate_c_file(package, file_path)
		end
	end)
end

--[[
TODO: use multiple threads to generate .t and c files
number of spawn threads will be equal to the number of CPU cores,
	or the number of Jina files, either one which is smaller
https://lualanes.github.io/lanes/
]]

if ospkg_type ~= "" then
	for package_name, package in pairs(packages_table) do
		os.execute("ospkg-" .. ospkg_type .. " add jina-" .. package_name .. " '" .. package.ospkg .. "'")
	end
end

local process_handles = {}

-- go through all files in all ".cache/jina/c/package_name" directories of all packages in packages_table
-- compile C files to object files
for package_name, package in pairs(packages_table) do
	local project_path = path.dirname(package.path)
	local c_dir_path = path.join(project_path, ".cache/jina/c", package_name)
	local o_dir_path = path.join(project_path, ".cache/jina/o", package_name)
	
	for _, c_file_path in ipairs(dir.getfiles(c_dir_path)) do
		local file_name = path.splitext(path.basename(c_file_path))
		
		-- if for the C file, there is no corresponding jina file, delete it and its .h and .o file
		local jin_file_path = path.join(project_path, file_name:replace("__", path.sep) .. ".jin")
		if not path.isfile(jin_file_path) then
			os.remove(c_file_path)
			os.remove(path.join(project_path, ".cache/jina/h", package_name, file_name..".h"))
			os.remove(path.join(project_path, ".cache/jina/o", package_name, file_name..".o"))
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
			if path.isfile(path.join(package.path, "0.jin")) then
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

-- go through all files in all ".cache/jina/o/package_name" directories of all packages in packages_table
-- link object files
-- iteration is done backward from the end, to link dependecies before dependants
for i = package_name_list.len(), 1, -1 do
	local package = packages_table[package_names_list[i]]
	local project_path, package_name = path.splitpath(package.path)
	local o_dir_path = path.join(project_path, ".cache/jina/o", package_name)
	local out_path = path.join(project_path, ".cache/jina/out", package_name)
	
	if package.needs_update then
		path.isdir(out_path) and dir.rmtree(out_path)
	end
	dir.makepath(out_path)
	
	if package_name ~= "std" then
		package.dlib = package.dlib.."-lstd.jin "
		os.execute("ln " .. path.expanduser("~/.local/apps/jina/libstd.jin.so") .. " " .. out_path)
	end
	
	-- if .so file exists, goto skip
	
	-- hardlink .so files of dependencies into out directory
	
	if path.isfile(path.join(project_path, "0.jin")) then
		local out_executable_path = path.join(out_path, package_name)
		os.execute(
			"gcc -Wl,-rpath-link=. -L. " .. package.dlibs .. gcc_options ..
			o_dir_path .. "/*.o -o " .. out_executable_path
		) or os.exit(false)
		os.execute("LD_LIBRARY_PATH=. " .. executable_path)
	else
		local out_lib_path = path.join(out_path, "lib" .. package_name .. ".jin.so")
		os.execute(
			"gcc -shared -Wl,-rpath-link=. -L. " .. package.dlibs .. gcc_options ..
			o_dir_path .. "/*.o -o " .. out_lib_path
		) or os.exit(false)
	end
	
	::skip::
end
