--[[
https://github.com/edubart/nelua-lang/tree/master/lualib/nelua
	https://github.com/edubart/nelua-lang/blob/master/lualib/nelua/ccompiler.lua
	https://github.com/edubart/nelua-lang/blob/master/lualib/nelua/cgenerator.lua
	https://github.com/edubart/nelua-lang/tree/master/lib
https://github.com/ceu-lang/ceu/tree/master/src/lua
	https://github.com/ceu-lang/ceu/blob/master/src/lua/codes.lua

https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html
https://sourceware.org/glibc/manual/latest/html_node/index.html
https://en.cppreference.com/w/c
https://devdocs.io/c/
https://pdos.csail.mit.edu/6.828/2017/readings/pointers.pdf
https://wiki.sei.cmu.edu/confluence/display/c/EXP35-C.+Do+not+modify+objects+with+temporary+lifetime
https://stackoverflow.com/questions/11656532/returning-an-array-using-c

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

records:
, constructed using anonymous structs (fields sorted alphabetically)
, assigned to variables with type void*
, casted to anonymous structs (fields sorted alphabetically) when accessed

functions are compiled to c functions with only one arg, which is a struct

API:
, exported types
, type of exported definitions

in Jina, API change implies ABI change; and API invarience implies ABI invarience
so for recompiling an object file, we just need to track the corresponding .c file,
	and not all the included .h files
https://begriffs.com/posts/2021-07-04-shared-libraries.html#api-vs-abi

https://github.com/Microsoft/mimalloc
libmimalloc-dev
]]

--[[
stacks are designed for sync computation
using a lot of them as async cores (stackful green threads) is inefficient

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

only the actor can destroy the heap references it creates
	other actors just send reference'counting messages
	so we do not need atomic reference counting
self'referential fields of structures are necessarily private, and use weak references
https://docs.gtk.org/glib/reference-counting.html
]]

function generate_c_file (pkg, pkg_id, jin_file_path)
	local project_path = path.dirname(pkg.path)
	local pkg_name = path.basename(pkg.path)
	
	local file_name_without_ext = path.splitext(
		path.relpath(jin_file_path, pkg.path)
	):replace(path.sep, "__")
	
	local h_file_path = path.join(project_path, ".cache/jina/h", pkg_name, file_name_without_ext..".h")
	
	local c_file_path = path.join(project_path, ".cache/jina/c", pkg_name, file_name_without_ext..".c")
	local c_file_mtime = path.getmtime(c_file_path)
	
	local jin_file_mtime = path.getmtime(jin_file_path)
	
	if
		jin_file_mtime and c_file_mtime and	c_file_mtime >= jin_file_mtime and
		os.time() >= c_file_mtime -- make sure that c file is not from future!
	then
		return
	end
	
	pkg.needs_compile or do pkg.needs_compile = true end
	
	-- fill the table of definitions and their types
	-- check for type consistency in the module, and with (cached) .t files
	-- compile to c
	
	local jin_file = io.open(jin_file_path)
	local c_file = io.open(c_file_path, "w")
	
	--[[
	#include "../include/libc/stdlib.h"
	#include "../include/glib2/glib.h"
	
	int main(int argc, char* argv[]) {}
	]]
	
	for line in jin_file:lines() do
		local c_code = ""
		--[[
		words: alpha'numerics plus apostrophe, dot or colon at the start or end
		if the second word is an operator (=, +, .add), find the type of first word, then build the function's name
		otherwise use the first word as the function's name
		if it's a definition, add it to the table of local definition which contains their types
		]]
		
		-- prefix all exported identifiers with pkg_id_
		
		--[[
		";include h-file package-name"
			first remove those packages already in pkg.spm, then:
			pkg.spm = pkg.spm .. package-name .. " "
		";dlibs"
			pkg.dlibs = pkg.dlibs .. "-l" .. package-name .. " "
		]]
		c_file:write(c_code)
	end
	
	-- generate .h file from .t file
end
