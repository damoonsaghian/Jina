#!/bin/python3

'''
https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html
https://en.cppreference.com/w/c
https://en.wikibooks.org/wiki/A_Little_C_Primer/C_Quick_Reference
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

https://github.com/Microsoft/mimalloc
libmimalloc-dev
'''

def generate_header_file(jina_file_path, h_file_path):
	# generate header and store it in a var
	# generate its hash
	# if there is an old header file (remained from the last compilation),
	# and it's not equal to the new one (compare their hashes), overwrite the old one
	# otherwise just keep the old one

def generate_c_file(jina_file_path, c_file_path):
	'''
	fill the table of module identifiers and their types
	check for type consistency in the module, and with header files
	compile to c
	
	read a line
	words: alpha'numerics plus apostrophe, dot or colon at the start or end
	if the second word is an operator (=, +, .add), find the type of first word, then build the function's name
	otherwise use the first word as the function's name
	if it's a definition, add it to the table of local definition which contains their types
	
	https://docs.python.org/3/
	https://docs.python.org/3/library/subprocess.html
	
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
	'''
	
	'''
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
	'''

import sys

if sys.argv[1] == None:
	printf("interactive Jina is not yet implemented")
	sys.exit()

project_dir_path = sys.argv[1]
src_dir_path = path.join(project_dir_path, "src")
if !path.isdir(src_dir_path):
	src_dir_path = project_dir_path
c_dir_path = path.join(project_dir_path, ".cache/jina/c")
o_dir_path = path.join(project_dir_path, ".cache/jina/o")
dir.makepath(c_dir_path)
dir.makepath(o_dir_path)

# generate C files, and add packages
def generate_c(jina_file_path):
	if src_dir_path.find"%.jin$":
		relpath_wo_ext, _ = path.splitext(
			path.relpath(jina_file_path, src_dir_path)
		)
		
		h_file_path = path.join(c_dir_path, relpath_wo_ext..".h")
		generate_header_file(jina_file_path, h_file_path)
		
		c_file_path = path.join(c_dir_path, relpath_wo_ext..".c")
		jina_file_mtime = path.getmtime(jina_file_path)
		c_file_mtime = path.getmtime(c_file_path)
		if jina_file_mtime > c_file_mtime:
			compile_jina2c(jina_file_path, c_file_path)
	elif src_dir_path:find"%.p$":
		# if gnunet or git is needed to add a package, and they are not installed on the system,
		# ask the user to install them first, then exit with error
		
		# packages will be downloaded to ~/.local/share/jina/packages/package-name
		# after compiling the package:
		# ln -s ~/.local/share/jina/packages/package-name/.cache/jina/so $project_dir/.cahce/jina/package-name.so
		# ln -s ~/.local/share/jina/packages/package-name/.cache/jina/c $project_dir/.cahce/jina/c/package-name
dir.getallfiles(src_dir_path).foreach(generate_c)

# the created binary will at least need glib2 and flint dynamic libraries
dlinks = "glib2,flint"

# compile C files to object files
def compile_c(c_file_path):
	relpath_wo_ext, _ = path.splitext(
		path.relpath(c_file_path, c_dir_path)
	)
	
	# if for the C file, there is no corresponding jina file, delete it and its header file, then return
	jina_file_path = path.join(src_dir_path, relpath_wo_ext..".jin")
	if not path.isfile(jina_file_path):
		os.remove(c_file_path)
		os.remove(path.join(c_dir_path, relpath_wo_ext)..".h")
		return
	
	o_file_name = relpath_wo_ext:gsub(path.sep, "__") .. ".o"
	o_file_path = path.join(o_dir_path, o_file_name)
	o_file_mtime = path.getmtime(o_file_path)
	
	mtimes = { path.getmtime(c_file_path) }
	# find the modification times of all included files, and add them to the list
	# also add the name of all system libs to dlinks
	
	# if the modification time of the C file or one of the files included in it,
	# is newer than the object file, recompile it
	for _, mtime in ipairs(mtimes):
		if mtime > o_file_mtime:
			if path.isfile(path.join(src_dir_path, "0.jin")):
				os.execute("gcc -Wall -Wextra -Wpedantic -c "..c_file_path.." -o "..o_file_path)
			else
				os.execute("gcc -Wall -Wextra -Wpedantic -fPIC -c "..c_file_path.." -o "..o_file_path)
			break
dir.getallfiles(c_dir_path, "%.c$").foreach(compile_c)

# link object files
if path.isfile(path.join(src_dir_path, "0.jin")):
	executable_path = path.join(project_path, ".cache/jina/0")
	os.execute("gcc "..o_dir_path.."/*.o -l{"..dlinks.."} -o "..executable_path)
	os.execute("LD_LIBRARY_PATH=. "..executable_path)
else
	os.execute("gcc -shared "..o_dir_path.."/*.o -l{"..dlinks.."} -o "..
		path.join(project_path, ".cache/jina/so")
	)
	
	# link object files in "projict_dir/test" directory, and run the created executable
	# LD_LIBRARY_PATH=.
