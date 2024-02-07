#!/bin/lua5.3

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
https://stackoverflow.com/questions/13716913/default-value-for-struct-member-in-c

string literals and functions in C are stored in code
https://stackoverflow.com/questions/3473765/string-literal-in-c
https://stackoverflow.com/questions/73685459/is-string-literal-in-c-really-not-modifiable

records and modules are implemented similarly:
record_name__field_name
module_name__var_name

https://github.com/Microsoft/mimalloc
libmimalloc-dev
]]

function generate_header_file(source_file_path)
end

function compile_jina2c(jina_file_path)
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
end

if arg[1] == nil then
	printf("interactive Jina is not yet implemented")
	quit(1)
end

local lfs = require "lfs"

local project_dir = arg[1]

-- compile Jina to C
for jina_file_name in lfs.dir(project_dir) do
	if jina_file_name:find(".jin$") then break end
	
	local jina_file_path = project_dir.."/"..file_name
	local c_file_path = project_dir.."/.cache/jina/"..jina_file_name:gsub(".jin$", ".c")
	
	generate_header_file(jina_file_path)
	-- if there is an old header file (remained from the last compilation),
	-- and it's not equal to the new one (compare their hashes), overwrite the old one
	-- otherwise just keep the old one
	
	local jina_file_mod_time = lfs.attributes(jina_file_path).modification
	local c_file_mod_time = lfs.attributes(c_file_path).modification
	if jina_file_mod_time > c_file_mod_time then compile_jina2c(jina_file_path) end
end

-- compile C
for c_file_name in lfs.dir(project_dir.."/.cache/jina") do
	local c_file_path = project_dir.."/.cache/jina/"..c_file_name
	local object_file_path = project_dir.."/.cache/jina/"..c_file_name:gsub(".c$", ".o")
	local c_file_mod_time = lfs.attributes(c_file_path).modification
	local object_file_mod_time = lfs.attributes(object_file_path).modification
	
	-- recompile any .c file that the creation time of it or one of the files included in it,
	-- is newer than the generated .o file
	-- gcc -Wall -Wextra -pedantic -c \"$project_dir\"/.cache/jina/file-name.c
end

--[[
linking object files:
, for programs (there is a file named "0.jina" in the project directory):
	gcc -o \"$project_dir\"/.cache/jina/bin \"$project_dir\"/.cache/jina/*.o
, for libraries:
	gcc -Wl,-soname,lib.so.$ver_maj -o \"$project_dir\"/.cache/jina/lib \"$project_dir\"/.cache/jina/*.o
	cp \"$project_dir\"/.cache/jina/lib /usr/local/lib/lib${lib_name}.so.${ver_maj}.${ver_min}
	ln -s /usr/local/lib/libjina.so.${ver_maj}.${ver_min} /usr/local/lib/libjina.so.$ver_maj
	ln -s /usr/local/lib/libjina.so.$ver_maj /usr/local/lib/libjina.so

to create dynamic libs:
	gcc -shared -fPIC -o lib.so \"$project_dir\"/.cache/jina/*.c
to link against a dynamic library called "lib" in the system lib path:
	gcc -llib -o \"$project_dir\"/.cache/jina/bin \"$project_dir\"/.cache/jina/*.o

the produced binary will at least need libc and glib2 dynamic libraries on the system
]]
