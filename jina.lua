#!/bin/lua5.3

--[[
http://crasseux.com/books/ctutorial/
https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html
http://nethack4.org/blog/building-c.html
https://www.learn-c.org/
https://en.wikibooks.org/wiki/C_Programming
https://en.wikibooks.org/wiki/A_Little_C_Primer/C_Quick_Reference
https://gist.github.com/eatonphil/21b3d6569f24ad164365
https://pdos.csail.mit.edu/6.828/2017/readings/pointers.pdf
https://libcello.org/

only the actor can destroy the heap references it creates
	other actors just send reference'counting messages
	so we do not need atomic reference counting
self'referential fields of structures are necessarily private, and use weak references
https://nullprogram.com/blog/2015/02/17/
https://github.com/jeraymond/refcount
https://snai.pe/posts/c-smart-pointers
	https://github.com/Snaipe/libcsptr

c closures
	https://stackoverflow.com/questions/4393716/is-there-a-a-way-to-achieve-closures-in-c
http://blog.pkh.me/p/20-templating-in-c.html
https://stackoverflow.com/questions/13716913/default-value-for-struct-member-in-c

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
	https://github.com/ceu-lang/ceu/blob/master/src/lua/codes.lua
	
	#include <stdlib.h>
	#include <stdint.h>
	
	int main(int argc, char* argv[]) {}
	]]
	
	--[[
	after calling the init function, create a fixed number of threads (the number is explained in the following)
	each thread runs a loop that processes the messages
	there are two kinds of loops:
	, plain loops: after each loop, if there are no messages left, it goes to sleep (sigwait)
	, I/O loops: after each loop, if there is are no messages left, it calls waiting I/O event processing function
		otherwise, it calls non'waiting I/O event processing function
	the primary thread always runs an I/O loop
	when a message is registered, a signal will be sent to all threads to wake up the slept ones,
		and also a dummy I/O request will be submited to wake up the I/O loops
	
	to implement an I/O backend just define these three functions:
	, event submiting function
	, non'waiting event processing function (batch)
	, waiting event processing function
	the I/O backend used in std is implemented using libuv
	one can implement an I/O backend using glib2 for example
	multiple I/O backends can work at the same time, by using multiple I/O loops
	available I/O backends will be put in a global list
	total number of threads is the maximum between number of CPU cores, and number of I/O backends
	
	use mutexes or atomics to hold list of actors
	https://www.classes.cs.uchicago.edu/archive/2018/spring/12300-1/lab6.html
	
	there can be two lists of actors: UI actors, and other actors
	only when there is no messages for UI actors, we go after other actors
	in this way, the UI remains resposive, even when the number of actors is extremely large
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

--[[
from .jina generate header files, and overwrite them, if not equal to the old ones (compare their hashes)
recompile any .jina file whose modification time is newer than the generated .c file

recompile any .c file that the creation time of it or one of the files included in it,
	is newer than the generated .o file
gcc -Wall -Wextra -pedantic -c \"$project_dir\"/.cache/jina/file-name.c

to create dynamic libs:
	gcc -c -fPIC \"$project_dir\"/.cache/jina/*.c
linking object files:
, for programs (there is a file named "0.jina" in the project directory):
	gcc -o \"$project_dir\"/.cache/jina/bin \"$project_dir\"/.cache/jina/*.o
, for libraries:
	gcc -Wl,-soname,lib.so.$ver_maj -o \"$project_dir\"/.cache/jina/lib \"$project_dir\"/.cache/jina/*.o
	cp \"$project_dir\"/.cache/jina/libo /usr/local/lib/lib${lib_name}.so.${ver_maj}.${ver_min}
	ln -s /usr/local/lib/libjina.so.${ver_maj}.${ver_min} /usr/local/lib/libjina.so.$ver_maj
	ln -s /usr/local/lib/libjina.so.$ver_maj /usr/local/lib/libjina.so

the produced binary will at least need libc and libevent-core dynamic libraries on the system
]]
