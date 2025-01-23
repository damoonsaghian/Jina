#!/usr/bin/env sh

script_dir="$(dirname "$(realpath "$0")")"

project_dir="$1"
c3c_config="$2"

if [ -z "$project_dir" ]; then
	echo "interactive Jina is not yet implemented"
	echo "usage: jina <project_path> [c3c_options]"
	exit
fi

[ -d "$project_dir" ] || {
	print "directory \"$project_dir\" does not exists"
	exit 1
}

generate_c3_file() {
	# variable, constant
	# pointer, constant pointer
	# array names are in fact constant pointers
	
	# multi'dimensional arrays in C cant have variable length
	# 	so function parameters can't be multi'dimensional arrays
	# variable length arrays can't be used in a struct, except as the last item
	
	# incomplete (unsized) types can't have a value
	# 1, void
	# 2, unsized array, that are usually in a header as an extern
	# 	they will be completed when linked
	# 3, struct or union when self refering
	# 	completedat the end of definition
	
	# struct members are not lvalues; so "&" can't be used; and if indexed,
	# 	they can't be modified in the same function call
	
	# string literals and functions in C are stored in code
	# https://stackoverflow.com/questions/3473765/string-literal-in-c
	# https://stackoverflow.com/questions/73685459/is-string-literal-in-c-really-not-modifiable
	
	# closures
	# https://stackoverflow.com/questions/4393716/is-there-a-a-way-to-achieve-closures-in-c
	# this defines a function named "fun" that takes a *char,
	# 	and returns a function that takes two ints and returns an int:
	# int (*fun(char* s)) (int, int) {}
	# int (*fun2)(int, int) = fun("")
	# function names are automatically converted to a pointer
	
	# pointers to functions (unlike function) are objects
	# the only thing we can do with functions, is to call them
	# but function pointer in addition to being called, can do other things that objects can
	
	# use generics and linked lists to implement records
	# sort the fields according to a deterministic rule by checking the types
	# https://andreyor.st/posts/2022-03-15-generic-tuples-in-c/
	
	# API:
	# , exported types
	# , type of exported definitions
	
	# in Jina, API change implies ABI change; and API invariance implies ABI invariance
	# so for recompiling an object file, we just need to track the corresponding .c file,
	# 	and not all the included .h files
	# https://begriffs.com/posts/2021-07-04-shared-libraries.html#api-vs-abi
	
	# https://github.com/Microsoft/mimalloc
	# libmimalloc-dev
	
	# stacks are designed for sync computation
	# using a lot of them as async cores (stackful green threads) is inefficient
	#
	# after calling the init function, create a fixed number of threads (as many as CPU cores),
	# 	and then run the main loop
	# each thread runs a loop that processes the messages
	# after each loop, if there are no messages left, it goes to sleep (sigwait)
	# when a message is registered, a signal will be sent to all threads to wake up the slept ones
	# https://docs.gtk.org/glib/main-loop.html
	# https://docs.gtk.org/glib/struct.MainLoop.html
	# https://docs.gtk.org/glib/threads.html
	# https://docs.gtk.org/glib/struct.Thread.html
	# https://docs.gtk.org/glib/struct.ThreadPool.html
	# https://docs.gtk.org/glib/struct.MainContext.html
	#
	# the main loop only runs messages of UI actors (which are kept in a separate list); this means that:
	# , a heavy computation that blocks its thread, can't make the UI lag
	# , the UI remains resposive, even when the number of non'UI actors is extremely large
	# the main loop runs messages of UI actors, and then polls (non'waiting) more events (glib2)
	# 	if there is no more messages for UI actors, wait for events
	#
	# GTK is not thread safe, but it can be made thread aware using "gdk_threads_enter" and "gdk_threads_leave"
	#
	# use mutexes to hold the list of actors and their message queues
	# https://www.classes.cs.uchicago.edu/archive/2018/spring/12300-1/lab6.html
	# https://docs.gtk.org/glib/struct.RWLock.html
	#
	# only the actor can destroy the heap references it creates
	# 	other actors just send reference'counting messages
	# 	so we do not need atomic reference counting
	# self'referential fields of structures are necessarily private, and use weak references
	# https://docs.gtk.org/glib/reference-counting.html
	
	local jin_file_path="$1"
	
	cat "$jin_file_path" | while read line; do
		# words: alpha'numerics plus apostrophe, dot or colon at the start or end
		# if the second word is an operator (=, +, .add), find the type of first word, then build the function's name
		# otherwise use the first word as the function's name
		# if it's a definition, add it to the table of local definition which contains their types
	done
}

for pkg in $(echo "$project_dir"/*.jin/); do
	# spm import glib and flint
	
	# go through all files (recursively) and find ".p" files
	for p_file in $(find .p); do
		cat "$p_file"
		
		# spm import <gnunet-namespace> <package-name>
	done
	
	# recursively go through all files in all packages in pkg_table
	# generate .c3 files from .jin files
	# number of parallel processes will be equal to the number of CPU cores,
	# 	or the number of Jina files, either one which is smaller
	
	# std.jin is compiled to c3 and imported to all the generated c3 files above
	
	# compile the generated c3 package
done
