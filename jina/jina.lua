#!/usr/bin/env lua

local path = require"pl/path"
local dir = require"pl/dir"
local omap = require"pl/OrderedMap"
require"pl.stringx".import()

function generate_t_file(project_path, jin_file_path)
	local relative_extensionless_path = path.splitext(
		path.relpath(jin_file_path, project_path)
	)
	
	local c_file_path = path.join(project_path, ".cache/jina/c", relative_extensionless_path..".c")
	local c_file_mtime = path.getmtime(c_file_path)
	
	local jin_file_mtime = path.getmtime(jin_file_path)
	
	if
		jin_file_mtime and c_file_mtime and	c_file_mtime >= jin_file_mtime and
		os.time() >= c_file_mtime -- make sure that c file is not from future!
	then
		return
	end
	
	local t_file_path = path.join(project_path, ".cache/jina/h", relative_extensionless_path..".t")
	
	--[[
	generate a string containing the exported definitions and their types
	then write the string into the .t file, if:
	, there is no old .t file remained from the last compilation
	, or there is an old .t file, but it's not equal to the generated string (compare their hashes)
	]]
	
	dir.makepath(path.dirname(t_file_path))
	local t_file_handle = io.open(t_file_path)
end

dlibs = {}

ospkg = {}
ospkg.type = ""
os.execute("command -v ospkg-deb 1>/dev/null") and ospkg.type = "deb"
ospkg.packages = ""

function generate_c_file(package, jin_file_path)
	local project_path = path.dirname(package.path)
	local package_name = path.basename(package.path)
	
	local extensionless_file_name = path.splitext(
		path.relpath(jin_file_path, root_path)
	):replace(path.sep, "__")
	
	local h_file_path = path.join(project_path, ".cache/jina/h", package_name, extensionless_file_name..".h")
	
	local c_file_path = path.join(project_path, ".cache/jina/c", package_name, extensionless_file_name..".c")
	local c_file_mtime = path.getmtime(c_file_path)
	
	local jin_file_mtime = path.getmtime(jin_file_path)
	
	if
		jin_file_mtime and c_file_mtime and	c_file_mtime >= jin_file_mtime and
		os.time() >= c_file_mtime -- make sure that c file is not from future!
	then
		return
	end
	
	package.needs_update or do package.needs_update = true end
	
	-- fill the table of definitions and their types
	-- check for type consistency in the module, and with (cached) .t files
	-- compile to c
	
	local jin_file = io.open(jin_file_path)
	local c_file = io.open(c_file_path, "w")
	
	for line in jin_file:lines() do
		local c_code = ""
		--[[
		words: alpha'numerics plus apostrophe, dot or colon at the start or end
		if the second word is an operator (=, +, .add), find the type of first word, then build the function's name
		otherwise use the first word as the function's name
		if it's a definition, add it to the table of local definition which contains their types
		]]
		
		--[[
		";ospkg-"..ospkg.type
			append to ospkg.packages
		";dlibs"
			add ot dlibs[package_name]
		]]
		c_file:write(c_code)
	end
	
	-- if correspoding .t file is newer than corresponding .h file, regenerate the .h file
	
	-- prefeix all exported identifiers with "package_name__"
	-- except when package name is "std"
	
	--[[
	https://github.com/edubart/nelua-lang/tree/master/lualib/nelua
		https://github.com/edubart/nelua-lang/blob/master/lualib/nelua/ccompiler.lua
		https://github.com/edubart/nelua-lang/blob/master/lualib/nelua/cgenerator.lua
		https://github.com/edubart/nelua-lang/tree/master/lib
	https://github.com/ceu-lang/ceu/tree/master/src/lua
		https://github.com/ceu-lang/ceu/blob/master/src/lua/codes.lua
	
	#include <stdlib.h>
	#include <glib-2.0/glib.h>
	; https://packages.debian.org/bookworm/amd64/libglib2.0-dev/filelist
	
	int main(int argc, char* argv[]) {}
	]]
	
	--[[
	https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html
		https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html#Pointers
	https://sourceware.org/glibc/manual/latest/html_node/index.html
	https://en.cppreference.com/w/c
	https://en.cppreference.com/w/c/language/value_category
	https://en.cppreference.com/w/c/language/restrict
	https://pdos.csail.mit.edu/6.828/2017/readings/pointers.pdf
	https://wiki.sei.cmu.edu/confluence/display/c/EXP35-C.+Do+not+modify+objects+with+temporary+lifetime

	https://web.archive.org/web/20051224211528/http://www.network-theory.co.uk/docs/gccintro/
		https://web.archive.org/web/20051215144235/http://www.network-theory.co.uk/docs/gccintro/gccintro_13.html
		https://web.archive.org/web/20051215144300/http://www.network-theory.co.uk/docs/gccintro/gccintro_14.html
		https://web.archive.org/web/20060116041513/http://www.network-theory.co.uk/docs/gccintro/gccintro_16.html
		https://web.archive.org/web/20051215144452/http://www.network-theory.co.uk/docs/gccintro/gccintro_18.html
		https://web.archive.org/web/20051215144519/http://www.network-theory.co.uk/docs/gccintro/gccintro_19.html
	https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html
		https://gcc.gnu.org/onlinedocs/gcc/Overall-Options.html
		https://gcc.gnu.org/onlinedocs/gcc/Static-Analyzer-Options.html
		https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html
		https://gcc.gnu.org/onlinedocs/gcc/Environment-Variables.html
		https://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html
		https://gcc.gnu.org/onlinedocs/gcc/Variable-Length.html
	https://www3.ntu.edu.sg/home/ehchua/programming/cpp/gcc_make.html
	https://docs.openeuler.org/en/docs/20.09/docs/ApplicationDev/using-gcc-for-compilation.html

	only the actor can destroy the heap references it creates
		other actors just send reference'counting messages
		so we do not need atomic reference counting
	self'referential fields of structures are necessarily private, and use weak references
	https://docs.gtk.org/glib/reference-counting.html

	c closures
	https://stackoverflow.com/questions/4393716/is-there-a-a-way-to-achieve-closures-in-c
	this defines a function named "fun" that takes a *char,
		and returns a function that takes two ints and returns an int:
	int (*fun(char* s)) (int, int) {}
	int (*fun2)(int, int) = fun("")
	funtion namse are automatically converted to a pointer

	http://blog.pkh.me/p/20-templating-in-c.html

	string literals and functions in C are stored in code
	https://stackoverflow.com/questions/3473765/string-literal-in-c
	https://stackoverflow.com/questions/73685459/is-string-literal-in-c-really-not-modifiable

	records and modules are implemented similarly:
	record_name__field_name
	module_name__var_name

	note that record types are not compiled to c structs
	records are implemented as multiple variables

	functions are compiled to c functions with only one arg, which is a struct
	adding members to the end of structs do not change ABI

	all these means that there is a one to one relation between API and ABI
	API change imply ABI change; API invarience imply ABI invarience
	so for recompiling an object file, we just need to track the corresponding .c file,
		and not all the included .h files

	https://github.com/Microsoft/mimalloc
	libmimalloc-dev
	]]
	
	--[[
	after calling the init function, create a fixed number of threads (as many as CPU cores),
		and then run the main loop
	each thread runs a loop that processes the messages
	after each loop, if there are no messages left, it goes to sleep (sigwait)
	when a message is registered, a signal will be sent to all threads to wake up the slept ones
	https://docs.gtk.org/glib/main-loop.html
	https://docs.gtk.org/glib/struct.MainLoop.html
	https://docs.gtk.org/glib/threads.html
	https://docs.gtk.org/glib/struct.Thread.html
	https://docs.gtk.org/glib/struct.ThreadPool.html
	https://docs.gtk.org/glib/struct.MainContext.html
	
	the main loop only runs messages of UI actors (which are kept in a separate list); this means that:
	, a heavy computation that blocks its thread, can't make the UI lag
	, the UI remains resposive, even when the number of non'UI actors is extremely large
	the main loop runs messages of UI actors, and then polls (non'waiting) more events (glib2)
		if there is no more messages for UI actors, wait for events
	
	use mutexes to hold the list of actors and their message queues
	https://www.classes.cs.uchicago.edu/archive/2018/spring/12300-1/lab6.html
	https://docs.gtk.org/glib/struct.RWLock.html
	]]
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

packages_omap = omap{}
-- each package has these fields: path, deps (list of dep paths), dlibs, ospkg
-- find all directories named "*.jin" inside arg[1] directory, and add them to packages
packages_omap:set()

--[[
for each package in packages, go through all files in package.path (recursively) and:
, from .jin files generate .t files
, for each "package_name.p" file, if it's not a "lib://" protocol package:
	download the package (if needed)
	inside the download, the directory with the name "package_name" contains the source of the package
	add it to root_paths
]]
local i = 1
while packages_omap[i] do
	local package = packages_omap[i]
	local project_path = path.dirname(package.path)
	local package_name = path.basename(package.path)
	
	local out_path = project_path.."/.cache/jina/out/"..package_name
	dir.makepath(out_path)
	
	dir.getallfiles(package.path):foreach(function (file_path)
		if file_path:find"%.jin$" then
			generate_t_file(project_path, file_path)
		elseif file_path:find"%.p$" then
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
				error('package:\n\t'..package.path..'\nneeds package:\n'..dep_package.path..
					"\nwhich does not exists")
			end
			
			--[[
			packages_omap:set(package_name, dep_package)
			
			if there is a key named "package_name" in packages_omap:
			, if its index is greater than "i", do nothing
			, else, sort elements between them, according to their dependecies
			
			do not allow cyclic dependencies
			
			package.dlibs = package.dlibs.."-l"..dep_package_name..".jin"
			]]
		end
	end)
	i = i + 1
end

-- recursively go through all files in all packages in packages_omap
-- generate .c and .h files from .jin and .t files
for _, package in ipairs(packages_omap) do
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

local process_handles = {}

-- go through all files in all ".cache/jina/c/package_name" directories of all packages in packages_omap
-- compile C files to object files
for package_name, package in package_omap:iter() do
	local project_path = path.dirname(package.path)
	local c_dir_path = path.join(project_path, ".cache/jina/c", package_name)
	
	for _, c_file_path in ipairs(dir.getfiles(c_dir_path)) do
		local file_name = path.splitext(
			path.basename(c_file_path)
		)
		
		-- if for the C file, there is no corresponding jina file, delete it and its .h and .o file
		local jin_file_path = path.join(root_path, file_name:replace("__", path.sep) .. ".jin")
		if not path.isfile(jin_file_path) then
			os.remove(c_file_path)
			os.remove(path.join(project_path, ".cache/jina/h", package_name, file_name..".h"))
			os.remove(path.join(project_path, ".cache/jina/o", package_name, file_name..".o"))
			goto skip
		end
		
		dir.makepath()
		
		local o_file_path = path.join(project_path, ".cache/jina/o", package_name, file_name..".o")
		local o_file_mtime = path.getmtime(o_file_path)
		
		local c_file_mtime = path.getmtime(c_file_path)
		
		if
			not c_file_mtime or not o_file_mtim or
			c_file_mtime > o_file_mtime or
			o_file_mtime > os.time() -- o_file is from future!
		then
			if path.isfile(path.join(root_path, "0.jin")) then
				local handle = io.popen(
					"gcc -Wall -Wextra -Wpedantic -c "..c_file_path.." -o "..o_file_path,
					"r"
				)
				table.insert(process_handles, handle)
			else
				local handle = io.popen(
					"gcc -Wall -Wextra -Wpedantic -fPIC -c "..c_file_path.." -o "..o_file_path,
					"r"
				)
				table.insert(process_handles, handle)
			end
			break
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
	gcc_options = gcc_options..arg[i].." "
end

-- go through all ".cache/jina/o/package_name" subdirectories of all directories in "root_paths/.."
-- link object files
-- iterate backwards from the end, to link dependecies before dependants
for i = #root_paths, 1, -1 do
	local project_path, package_name = path.splitpath(root_paths[i])
	local o_dir_path = path.join(project_path, ".cache/jina/o", package_name)
	local out_path = path.join(project_path, ".cache/jina/out", package_name)
	
	if package.needs_update then
		path.isdir(out_path) and dir.rmtree(out_path)
		dir.makepath(out_path)
	end
	
	if package_name ~= "std" then
		package.dlib = "-lstd.jin "
		os.execute("ln "..path.expanduser("~/.local/packages/jina/libstd.jin.so").." "..out_path)
	end
	
	-- if .so file exists, goto skip
	
	-- hardlink .so files of dependencies into out directory
	
	if path.isfile(path.join(project_path, "0.jin")) then
		local out_executable_path = path.join(project_path, ".cache/jina/out/lib"..package_name..".jin.so")
		os.execute(
			"gcc -Wl,-rpath-link=. -L. "..dlibs[package_name]..gcc_options..
			o_dir_path.."/*.o -o "..out_executable_path
		) or os.exit(false)
		os.execute("LD_LIBRARY_PATH=. "..executable_path)
	else
		local out_lib_path = path.join(out_path, package_name)
		os.execute(
			"gcc -shared -Wl,-rpath-link=. -L. "..dlibs[package_name]..gcc_options..
			o_dir_path.."/*.o -o "..out_lib_path
		) or os.exit(false)
	end
	
	::skip::
end
