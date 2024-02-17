#!/bin/lua

--[[
https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html
https://en.cppreference.com/w/c
https://en.wikibooks.org/wiki/A_Little_C_Primer/C_Quick_Reference
https://gist.github.com/eatonphil/21b3d6569f24ad164365
https://pdos.csail.mit.edu/6.828/2017/readings/pointers.pdf
https://libcello.org/

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

https://github.com/Microsoft/mimalloc
libmimalloc-dev
]]

function generate_header_file(jina_file_path, h_file_path)
	-- generate header and store it in a var
	-- generate its hash
	-- if there is an old header file (remained from the last compilation),
	-- and it's not equal to the new one (compare their hashes), overwrite the old one
	-- otherwise just keep the old one
end

function generate_c_file(jina_file_path, c_file_path)
	--[[
	fill the table of module identifiers and their types
	check for type consistency in the module, and with header files
	compile to c
	
	read a line
	words: alpha'numerics plus apostrophe, dot or colon at the start or end
	if the second word is an operator (=, +, .add), find the type of first word, then build the function's name
	otherwise use the first word as the function's name
	if it's a definition, add it to the table of local definition which contains their types
	
	https://lunarmodules.github.io/luafilesystem/
	https://lunarmodules.github.io/luafilesystem/manual.html
	
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
	
	-- packages are included as system files (using "<>")
	
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

function add_package()
	-- if a module is imported using gnunet or git, see if gnunet/git is installed
	-- and if not, ask the user to install them first, then exit with error
	
	-- packages are downloaded to ~/.local/share/jina/packages/package-name
	-- compiled to ~/.cache/jina/lib/package-name.so
end

if arg[1] == nil then
	printf("interactive Jina is not yet implemented")
	os.exit()
end

local path = require "pl/path"
local dir = require "pl/dir"

local project_dir_path = arg[1]
local src_dir_path = path.join(project_dir_path, "src")
if not path.isdir(src_dir_path) then
	src_dir_path = project_dir_path
end
local c_dir_path = path.join(project_dir_path, ".cache/jina/c")
local o_dir_path = path.join(project_dir_path, ".cache/jina/o")
dir.makepath(c_dir_path)
dir.makepath(o_dir_path)

-- generate C files
dir.getallfiles(src_dir_path, "%.jin$"):foreach(function (jina_file_path)
	local relpath_wo_ext, _ = path.splitext(
		path.relpath(jina_file_path, src_dir_path)
	)
	
	local h_file_path = path.join(c_dir_path, relpath_wo_ext..".h")
	generate_header_file(jina_file_path, h_file_path)
	
	local c_file_path = path.join(c_dir_path, relpath_wo_ext..".c")
	local jina_file_mtime = path.getmtime(jina_file_path)
	local c_file_mtime = path.getmtime(c_file_path)
	if jina_file_mtime > c_file_mtime then
		compile_jina2c(jina_file_path, c_file_path)
	end
end)

-- the created binary will at leat need glib2 and flint dynamic libraries
local dlinks = "glib2,flint"

-- compile C files to object files
dir.getallfiles(c_dir_path, "%.c$"):foreach(function (c_file_path)
	local relpath_wo_ext, _ = path.splitext(
		path.relpath(c_file_path, c_dir_path)
	)
	
	-- if for the C file, there is no corresponding jina file, delete it and its header file, then return
	local jina_file_path = path.join(src_dir_path, relpath_wo_ext..".jin")
	if not path.isfile(jina_file_path) then
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
			os.execute("gcc -Wall -Wextra -Wpedantic -c "..c_file_path.." -o "..o_file_path)
			break
		end
	end
end)

-- link object files
if path.isfile(path.join(src_dir_path, "0.jin")) then
	local out_file_path = path.join(project_path, ".cache/jina/0")
	os.execute("gcc -l{" .. dlinks .. "} -o " ..
		out_file_path .. " " ..
		o_file_path .. "/*.o"
	)
	os.execute("LD_LIBRARY_PATH=~/.cache/jina/lib "..out_file_path)
else
	os.execute("gcc -Wl,-soname,lib.so.$ver -l{" .. dlinks .. "} -o " ..
		path.join(project_path, ".cache/jina/so") .. " " ..
		o_file_path .. "/*.o"
	)
	
	-- link object files in "projict_dir/test" directory, and run the created executable
	-- LD_LIBRARY_PATH=~/.cache/jina/lib
end
