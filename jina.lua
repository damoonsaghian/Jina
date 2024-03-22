#!/usr/bin/env lua

--[[
https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html
https://en.cppreference.com/w/c
https://gist.github.com/eatonphil/21b3d6569f24ad164365
https://pdos.csail.mit.edu/6.828/2017/readings/pointers.pdf
https://libcello.org/

https://en.cppreference.com/w/c/language/value_category
https://en.cppreference.com/w/c/language/restrict
https://wiki.sei.cmu.edu/confluence/display/c/EXP35-C.+Do+not+modify+objects+with+temporary+lifetime
https://sourceware.org/glibc/manual/html_node/index.html
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
https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html#Pointers
https://www3.ntu.edu.sg/home/ehchua/programming/cpp/gcc_make.html
https://docs.openeuler.org/en/docs/20.09/docs/ApplicationDev/using-gcc-for-compilation.html

only the actor can destroy the heap references it creates
	other actors just send reference'counting messages
	so we do not need atomic reference counting
self'referential fields of structures are necessarily private, and use weak references
https://docs.gtk.org/glib/reference-counting.html

c closures
https://stackoverflow.com/questions/4393716/is-there-a-a-way-to-achieve-closures-in-c

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

function generate_t_file(jin_file_path, t_file_path)
	--[[
	generate a string containing the exported definitions and their types
	then write the string into the .t file, if:
	, there is no old .t file remained from the last compilation
	, or there is an old .t file, but it's not equal to the generated string (compare their hashes)
	]]
end

function generate_c_file(jin_file_path, c_file_path)
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
		c_file:write(c_code)
	end
	
	-- if correspoding .t file is newer than corresponding .h file, regenerate the .h file
	
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
	io.write("interactive Jina is not yet implemented\n")
	io.write("to compile a project: jina <project_dir_path> [gcc_options]\n")
	os.exit()
end
if arg[1]:char(1) == "-" then
	io.write("usage: jina <project_dir_path> [gcc_options]\n")
	os.exit()
end

local path = require "pl/path"
local dir = require "pl/dir"

local project_dir_path = arg[1]
if not path.isdir(project_dir_path) then
	error("there is no directory at \""..project_dir_path.."\"\n")
end

local src_dir_path = path.join(project_dir_path, "src")
if not path.isdir(src_dir_path) then
	error("there is no \"src\" directory in \""..project_dir_path.."\"\n")
end

local test_dir_path = path.join(project_dir_path, "test")

local c_dir_path = path.join(project_dir_path, ".cache/jina/c")
dir.makepath(c_dir_path)

local h_dir_path = path.join(project_dir_path, ".cache/jina/h")
dir.makepath(h_dir_path)

local o_dir_path = path.join(project_dir_path, ".cache/jina/o")
dir.makepath(o_dir_path)

-- go through all files in all directories in root_paths (recursively)
-- for each .p file, download the package (if necessary), and add its "src" directory to root_paths
-- generate .t files from .jin files
local dlibs = "glib2,flint"
local root_paths = {src_dir_path, test_dir_path}
local i = 1
while root_paths[i] do
	dir.getallfiles(root_paths[i]):foreach(function (file_path)
		if file_path:find"%.jin$" then
			local relpath_wo_ext, _ = path.splitext(
				path.relpath(jin_file_path, src_dir_path)
			)
			
			local t_file_path = path.join(c_dir_path, relpath_wo_ext..".t")
			generate_t_file(jin_file_path, t_file_path)
			
			local c_file_path = path.join(c_dir_path, relpath_wo_ext..".c")
			local jin_file_mtime = path.getmtime(jin_file_path)
			local c_file_mtime = path.getmtime(c_file_path)
			if jin_file_mtime > c_file_mtime then
				compile_jina2c(jin_file_path, c_file_path)
			end
		elseif file_path:find"%.p$" then
			table.insert(package_paths, file_path)
			-- if gnunet or git is needed to add a package, and they are not installed on the system,
			-- ask the user to install them first, then exit with error
			
			-- packages will be downloaded to ~/.local/share/jina/packages/package-name
			-- after compiling the package:
			-- ln -s ~/.local/share/jina/packages/package-name/.cache/jina/so $project_dir/.cahce/jina/package-name.so
			-- ln -s ~/.local/share/jina/packages/package-name/.cache/jina/c $project_dir/.cahce/jina/c/package-name
		end
	end)
	i = i + 1
end

-- go through all files in all directories in root_paths (recursively)
-- generate .c and .h files from .jin and .t files
for _, root_path in ipairs(root_paths) do
	dir.getallfiles(root_path):foreach(function (file_path)
		if file_path:find"%.jin$" then
		end
	end)
end

-- compile C files to object files
dir.getallfiles(c_dir_path, "%.c$"):foreach(function (c_file_path)
	local relpath_wo_ext, _ = path.splitext(
		path.relpath(c_file_path, c_dir_path)
	)
	
	-- if for the C file, there is no corresponding jina file, delete it and its header file, then return
	local jin_file_path = path.join(src_dir_path, relpath_wo_ext..".jin")
	if not path.isfile(jin_file_path) then
		os.remove(c_file_path)
		os.remove(path.join(c_dir_path, relpath_wo_ext)..".h")
		return
	end
	
	local o_file_name = relpath_wo_ext:gsub(path.sep, "__") .. ".o"
	local o_file_path = path.join(o_dir_path, o_file_name)
	local o_file_mtime = path.getmtime(o_file_path)
	
	local mtimes = { path.getmtime(c_file_path) }
	-- find the modification times of all included files, and add them to the list
	-- also add the name of all system libs to dlinks
	
	-- if the modification time of the C file or one of the files included in it,
	-- is newer than the object file, recompile it
	for _, mtime in ipairs(mtimes) do
		if mtime > o_file_mtime then
			if path.isfile(path.join(src_dir_path, "0.jin")) then
				os.execute("gcc -Wall -Wextra -Wpedantic -c "..c_file_path.." -o "..o_file_path)
			else
				os.execute("gcc -Wall -Wextra -Wpedantic -fPIC -c "..c_file_path.." -o "..o_file_path)
			end
			break
		end
	end
end)

-- link object files
if path.isfile(path.join(src_dir_path, "0.jin")) then
	local executable_path = path.join(project_path, ".cache/jina/0")
	os.execute("gcc "..o_dir_path.."/*.o -l{"..dlinks.."} -o "..executable_path)
	os.execute("LD_LIBRARY_PATH=. "..executable_path)
else
	os.execute("gcc -shared "..o_dir_path.."/*.o -l{"..dlinks.."} -o "..
		path.join(project_path, ".cache/jina/so")
	)
	
	-- link object files in "projict_dir/test" directory, and run the created executable
	-- LD_LIBRARY_PATH=.
end
