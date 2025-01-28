#!/usr/bin/env sh

script_dir="$(dirname "$(realpath "$0")")"

project_dir="$1"

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
	# multi'dimensional arrays in C cant have variable length
	# 	so function parameters can't be multi'dimensional arrays
	# variable length arrays can't be used in a struct, except as the last item
	
	# named tuples
	
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
	# self'referential fields of structures are necessarily private, and use weak references
	# https://docs.gtk.org/glib/reference-counting.html
	
	local jin_file_path="$1"
	
	cat "$jin_file_path" | while read line; do
		# words: alpha'numerics plus apostrophe, dot at start or colon at start or end
	done
}

for pkg in $(echo "$project_dir"/*.jin/); do
	# if --no-evloop is not used
	spm import $gnunet_namespace glib
	# if --no-flint is not used
	spm import $gnunet_namespace flint
	
	# go through all files (recursively) and find ".p" files
	for p_file in $(find .p); do
		cat "$p_file"
		
		# spm import <gnunet-namespace> <package-name>
	done
	
	mkdir -p "$project_dir/.cache/jina/c3"
	
	# find all .jina files (recursively), and if it's newer that the last generated .c3 file,
	# 	regenerate the .c3 file
	# number of parallel processes will be equal to the number of CPU cores,
	# 	or the number of .jin files, either one which is smaller
	c3_file_path=
	c3_file_mtime=
	jin_file_mtime=
	if [ ! jin_file_mtime ] || [ ! c3_file_mtime ] ||
		[ -gt jin_file_mtime c3_file_mtime ] ||
		[ -gt c3_file_mtime "$(time)" ] # c3_file is from future!
	then
	fi
	
	# std.jin is compiled to c3 and imported to all the generated c3 files above
	
	cat <<-EOF > "$project_dir/.cache/jina/c3/project.json"
	{
		"dependencies": [ "flint" ],
		"targets": {
    		"linux-$ARCH": {
				"type": "executable",
			},
		}
	}
	EOF
	
	# compile the generated c3 project
	c3c build $c3c_options "$project_dir/.cache/jina/c3"
done
