import std::io;

fn String! read_jina_exp(File jina_file) {
	do {
		String! line = io::readline(&jin_file);
		if (catch excuse = line) {
			jin_file.close();
			break;
		}
	};
}

fn String jina2c3(String jina_exp) {
	// words: alpha'numerics plus apostrophe, dot at start or colon at start or end
}

fn void generate_c3_file(String jin_file_path) {
	/*
	literals
	numbers (words starting with a digit):
	, remove apostrophes
	, if there is no point or "e", prepend with "(Int)" cast
	, otherwise, prepend with "(Float)" cast
	
	characters: 'a' '\n' '\x12'
	
	operators:
	a + b		a .add b
	a * b		a .mul b
	a /	b		a .div b
	a ^ b		a .exp b
	- a			a.neg()
	a == b		a .is'eq b
	a -= b		a .not'eq b
	a > b		a .is'more b
	a >= b		a .is'more'eq b
	
	multi'dimensional arrays in C cant have variable length
		so function parameters can't be multi'dimensional arrays
	variable length arrays can't be used in a struct, except as the last item
	
	tuple and union generic type
	named tuples
	
	stacks are designed for sync computation
	using a lot of them as async cores (stackful green threads) is inefficient
	
	function: { | }
	replace with: fn () {}
	if the function is only made of one expression, replace with: fn () @inline {}
	
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
	
	after running a message, if it returns false, remove the message from the list
	messages will be reapted until they return false
	
	a linked list containing tuples of actor's ID and memory address
	std::collections::LinkedList{Actor}* GLOBAL_actors_list;
	
	// if --no-evloop is not used
	GMainLoop eventloop = g_main_loop_new(); 
	
	the main loop only runs messages of UI actors (which are kept in a separate list); this means that:
	, a heavy computation that blocks its thread, can't make the UI lag
	, the UI remains resposive, even when the number of non'UI actors is extremely large
	the main loop runs messages of UI actors, and then polls (non'waiting) more events (glib2)
		if there is no more messages for UI actors, wait for events
	
	GTK is not thread safe, but it can be made thread aware using "gdk_threads_enter" and "gdk_threads_leave"
	
	use mutexes to hold the list of actors and their message queues
	https://www.classes.cs.uchicago.edu/archive/2018/spring/12300-1/lab6.html
	https://docs.gtk.org/glib/struct.RWLock.html
	*/
	io::File! jin_file = io::File::open(jin_file_path, "r");
	if (catch excuse = jin_file?) {
		io::printfn("file \"%s\" does not exist", jin_file_path);
	}
	
	// create c3 file
	io::File! c3_file = io::File::open(c3_file_path, "w");
	if (catch excuse = c3_file?) {
		io::printfn("file \"%s\" does not exist", c3_file_path);
	}
	
	String jina_exp;
	String c3_exp;
	do {
		jina_exp = read_exp(&jin_file_path);
		c3_exp = jina2c3(jina_exp);
		c3_file.write(c3_exp);
		
		if (catch excuse = jina_exp) {
			jin_file.close();
			c3_file.close();
			break;
		}
	};
}

fn generate_jina_api_file() {
	// distributed with compiled packages, for IDE hints
}

fn void? main(String[] args) {
	if (args.len == 0) {
		io::printn("interactive Jina is not yet implemented");
		io::printn("usage: jina <project_path> [c3c_options]");
		return;
	}
	
	io::Path! project_dir = io::Path::new(args[1]);
	if (catch excuse = project_dir) {
		io::printfn("directory \"%s\" does not exist", project_dir);
		return excuse?;
	} else if (! project_dir.is_dir()) {
		io::printfn("\"%s\" is not a directory", project_dir);
	}
	
	/*
	using glib for eventloop is not such a bad idea
	glib is already used in lots of system libraries and services
	in the future we can rewrite them (even those written in C++) in Jina
	eventually we can implement std.jin, media.jin, and gui.jin completely in Jina and C3,
		without using flint, glib, gstreamer, and gtk
	*/
	
	// if build target is "ELF freestanding" (kernel or embeded), link statically, and use --no-evloop
	
	foreach (pkg : io::Path.ls()) {
		// if --no-evloop is not used
		"spm import $gnunet_namespace glib"
		
		// go through all files (recursively) and find ".p" files
		foreach (p_file : $(find .p)) {
			cat p_file
			
			// spm import <gnunet-namespace> <package-name>
		}
		
		mkdir -p "$project_dir/.cache/jina/c3"
		
		/*
		find all .jina files (recursively), and if it's newer that the last generated .c3 file,
			regenerate the .c3 file
		number of parallel processes will be equal to the number of CPU cores,
			or the number of .jin files, either one which is smaller
		*/
		String c3_file_path = ;
		String c3_file_mtime = ;
		String jin_file_mtime = ;
		if (! jin_file_mtime || ! c3_file_mtime ||
			jin_file_mtime > c3_file_mtime ||
			c3_file_mtime > std::time:: // c3_file is from future!
		) {}
		
		// std.jin is compiled to c3 and imported to all the generated c3 files above
		
		/*
		cat <<-EOF > "$project_dir/.cache/jina/c3/project.json"
		{
			"dependencies": [ "glib" ],
			"targets": {
				"linux-$ARCH": {
					"type": "executable",
				},
			}
		}
		EOF
		*/
		
		// compile the generated c3 project
		// c3c build $c3c_options "$project_dir/.cache/jina/c3"
	}
}
