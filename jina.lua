#!/bin/lua5.3

--[[
https://www.geeksforgeeks.org/c-language-introduction
http://crasseux.com/books/ctutorial/
http://crasseux.com/books/ctutorial/The-form-of-a-C-program.html
https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html
https://www.learn-c.org/
https://en.wikibooks.org/wiki/C_Programming
https://en.wikibooks.org/wiki/A_Little_C_Primer/C_Quick_Reference
https://pdos.csail.mit.edu/6.828/2017/readings/pointers.pdf
https://nullprogram.com/blog/2014/10/21/
https://nullprogram.com/blog/2015/02/17/
https://github.com/Snaipe/libcsptr
https://github.com/jeraymond/refcount

https://github.com/oz123/awesome-c
]]

function generate_header_file(source_file_path)
end

function compile_jina2c(jina_file_path)
	--[[
	fill the table of identifiers (module identifiers and local ones) and their types
	check for type consistency in the module, and with header files
	compile to c
	]]
	
	--[[
	only the actor can destroy the heap references it creates
	other actors just send reference counting messages
	so we do not need atomic reference counting
	]]
	
	-- self'referential fields of structures are necessarily private, and use weak references
end

function add_package()
	-- if a module is imported using gnunet or git, see if they are installed
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
]]
