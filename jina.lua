#!/bin/lua5.3

--[[
https://www.geeksforgeeks.org/c-language-introduction
http://crasseux.com/books/ctutorial/
https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html
http://nethack4.org/blog/building-c.html
https://www.learn-c.org/
https://en.wikibooks.org/wiki/C_Programming
https://en.wikibooks.org/wiki/A_Little_C_Primer/C_Quick_Reference
https://gist.github.com/eatonphil/21b3d6569f24ad164365
https://pdos.csail.mit.edu/6.828/2017/readings/pointers.pdf
https://nullprogram.com/blog/2014/10/21/
https://nullprogram.com/blog/2015/02/17/
https://github.com/Snaipe/libcsptr
https://github.com/jeraymond/refcount
https://github.com/oz123/awesome-c

https://en.wikibooks.org/wiki/C_Programming/POSIX_Reference/dirent.h
https://en.wikibooks.org/wiki/C_Programming/POSIX_Reference/sys/stat.h
https://en.wikibooks.org/wiki/C_Programming/stdio.h
https://en.wikipedia.org/wiki/Unistd.h

c closures
	https://stackoverflow.com/questions/4393716/is-there-a-a-way-to-achieve-closures-in-c
http://blog.pkh.me/p/20-templating-in-c.html
https://stackoverflow.com/questions/13716913/default-value-for-struct-member-in-c
]]

-- https://lunarmodules.github.io/luafilesystem/
-- https://lunarmodules.github.io/luafilesystem/manual.html

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
	
	https://github.com/ceu-lang/ceu
	]]
	
	--[[
	only the actor can destroy the heap references it creates
	other actors just send reference'counting messages
	so we do not need atomic reference counting
		
	self'referential fields of structures are necessarily private, and use weak references
	]]
	
	--[[
	only IO and iteration can block thread
	so just implement non'blocking IO and iteration, by deviding the heavy computation,
		into multiple messages set to the corresponding actor
	https://medium.com/ing-blog/how-does-non-blocking-io-work-under-the-hood-6299d2953c74
	
	message processing loop: it runs messages across a fixed number of threads (equal to CPU cores),
		and then waits for events, which includes I/O events, and "message received" event
	after registering a message run "event_active()" for message received event
	https://stackoverflow.com/questions/7645217/user-triggered-event-in-libevent
	#include <event.h>
	
	similarly, other event loops (eg GUI loops) can be integrated easily
	just run the GUI event loop in a separate thread, then create a libevent event, add it with event_add(),
		and then activate it using event_active(), whenever a GUI event is raised in the GUI event loop
	GUI event will have the heighest proirity
	
	after running calling the init function, if the list of actors isn't empty,
		enter the message processing loop
	
	use mutexes or atomics to hold list of actors
	https://www.classes.cs.uchicago.edu/archive/2018/spring/12300-1/lab6.html
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
