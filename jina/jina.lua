local path = require"pl/path"
local dir = require"pl/dir"
local utils = require"pl.utils"
require"pl.stringx".import()

local generate_t_file = require"jina.generate_t_file"
local generate_c_file = require"jina.generate_c_file"

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
	print('directory "'..arg[1]..'" does not exists')
	os.exit(false)
end

local src_id_list = {}
local src_table = {}
-- { src_id = { path = "", dlibs = "-la -lb ", ospkg ="a,b," } }
-- src_id can be "app", "lib", "test", or the url_hash of a package

if path.isfile(path.join(arg[1], "app", "0.jina")) then
	table.insert(src_id_list, "app")
end
if path.isfile(path.join(arg[1], "test", "0.jina")) then
	table.insert(src_id_list, "test")
end
if path.isdir(path.join(arg[1], "lib")) then
	table.insert(src_id_list, "lib")
end
if #src_id_list == 0 then
	print'there is no "app/0.jin" file, nor a "lib" directory, in the project directory'
	os.exit()
end

--[[
for each entry in src_id_list, go through all files in package.path (recursively) and:
, from .jin files generate .t files
, for each ".p" file:
	download the package (if needed)
	add its url_has to src_id_list
]]
local i = 1
while src_id_list[i] do
	local src_id = src_id_list[i]
	
	local src_path
	if src_id == "app" then
		src_path = path.join(arg[1], "app")
	elseif src_id == "test" then
		src_path = path.join(arg[1], "test")
	elseif src_id = "lib" then
		src_path = path.join(arg[1], "lib")
	else
		src_path = path.join(path.expanduser"~/.local/share/jina/packages", src_id,	"lib")
	end

	local src = src_table[src_id]
	local project_path = path.dirname(src_path)
	
	dir.getallfiles(src_path):foreach(function (file_path)
		if file_path:find"%.jin$" then
			generate_t_file(project_path, file_path)
		elseif file_path:find"%.p$" then
			local url, public_key
			local url_is_available = false
			for line in io.lines(file_path) do
				if url then
					if url_is_available then break end
					
					url = line
					public_key = nil
					
					-- if gnunet or git is needed to add a package, and they are not installed on the system,
					-- ask the user to install them first, then exit with error
					
					-- try to download the url to ~/.local/share/jina/packages/url_hash/
					-- if successful: url_is_available=true
				else
					public_keykey =
				end
			end
			
			if public_key then
				-- use the public key to check the signature (".data/sig")
				-- if invalid, notice then os.exit(false)
			end
			
			local _, _, url_hash = utils.executeex('echo -n ' .. url .. ' | md5sum | cut -d " " -f1')
			
			local dep_ser_id, dep_src_path, dep_name
			if url then
				dep_src_id = url_hash
				dep_src_path = path.join(path.expanduser"~/.local/share/jina/packages", url_hash, "lib")
				dep_name = path.splitext(path.basename(file_path)) .. "-" .. url_hash
			else
				-- if there is no entry in the .p file
				dep_src_id = "lib"
				dep_src_path = path.join(project_path, "lib")
				dep_name = path.splitext(path.basename(file_path))
			end
			
			if not src_table[dep_src_id] then
				src.dlibs = src.dlibs .. "-l" .. dep_name
				table.insert(src_id_list, dep_src_id)
				src_table[dep_src_id] = { path = dep_src_path }
			else
				-- cyclic dependency
				-- this line is for compatiblity with linkers in which the order of given libs are important
				src.dlibs = src.dlibs .. "-l" .. dep_name
			end
		end
	end)
	i = i + 1
end

-- recursively go through all files in all sources in src_table
-- generate .c and .h files from .jin and .t files
for _, src in pairs(src_table) do
	dir.getallfiles(src.path):foreach(function (file_path)
		if file_path:find"%.jin$" then
			generate_c_file(src, file_path)
		end
	end)
end

--[[
TODO: use multiple threads to generate .t and c files
number of spawn threads will be equal to the number of CPU cores,
	or the number of Jina files, either one which is smaller
https://lualanes.github.io/lanes/
]]

local _, _, project_path_hash = utils.executeex('echo -n ' .. arg[1] .. ' | md5sum | cut -d " " -f1')
local ospkg_packages = ""
for _, src in pairs(src_table) do
	ospkg_packages = ospkg_packages..src.ospkg..","
end
if ospkg_type ~= "" then
	os.execute("ospkg-"..ospkg_type .. " add jina-"..project_path_hash .. " " .. ospkg_packages)
end

local process_handles = {}

-- go through all files in all c_dir_path of all sources in src_table
-- compile C files to object files
for _, src in pairs(src_table) do
	local project_path = path.dirname(src.path)
	local c_dir_path = path.join(project_path, ".cache/jina/c", path.basename(src.path))
	local o_dir_path = path.join(project_path, ".cache/jina/o", path.basename(src.path))
	
	for _, c_file_path in ipairs(dir.getfiles(c_dir_path)) do
		local file_name = path.splitext(path.basename(c_file_path))
		
		-- if for the C file, there is no corresponding jina file, delete it and its .h and .o file
		local jin_file_path = path.join(project_path, file_name:replace("__", path.sep) .. ".jin")
		if not path.isfile(jin_file_path) then
			os.remove(c_file_path)
			os.remove(path.join(project_path, ".cache/jina/h", path.basename(src.path), file_name..".h"))
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
			if path.isfile(path.join(src.path, "0.jin")) then
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

-- go through all files in all o_dir_path of all sources in src_table
-- link object files
-- iteration is done backward from the end, to create dependecies before dependants
for i = #src_id_list, 1, -1 do
	local src_id = src_id_list[i]
	local src = src_table[src_id]
	local project_path, root_dir = path.splitpath(src.path)
	local o_dir_path = path.join(project_path, ".cache/jina/o", root_dir)
	local out_path = path.join(project_path, ".cache/jina/out", root_dir)
	
	if src.needs_update then
		path.isdir(out_path) and dir.rmtree(out_path)
	end
	dir.makepath(out_path)
	
	os.execute("ln -f " .. path.expanduser("~/.local/apps/jina/libjina.so") .. " " .. out_path) or do
		src.dlib = src.dlib .. "-lstd "
	end
	
	-- hardlink .so files of dependencies into out directory
	
	local url_hash = ""
	if src_id ~= "app" and src_id ~= "test" and src_id ~= "lib" then
		url_hash = src_id
	end
	
	-- if compilation result exists already, goto skip
	if 
		root_dir == "lib" and path.isfile(path.join(out_path, "lib"..url_hash..".so")) or
		root_dir == "test" and path.isfile(path.join(out_path, "0")) or
		root_dir == "app" and path.isfile(path.join(out_path, "0"))
	then
		goto skip
	end
	
	if path.isfile(path.join(src.path, "0.jin")) then
		local out_executable_path = path.join(out_path, "0")
		os.execute(
			"gcc -Wl,-rpath-link=. -L. " .. gcc_options .. o_dir_path.."/*.o " .. src.dlibs ..
			" -o " .. out_executable_path
		) or os.exit(false)
		os.execute("LD_LIBRARY_PATH=. " .. out_executable_path)
	else
		local out_lib_path = path.join(out_path, "lib" .. url_hash .. ".so")
		os.execute(
			"gcc -shared -Wl,-rpath-link=. -L. " .. gcc_options .. o_dir_path.."/*.o " .. src.dlibs ..
			" -o " .. out_lib_path
		) or os.exit(false)
	end
	
	::skip::
end
