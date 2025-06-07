#include <iostream>
#include <optional>
#include <string>

using namespace std;

optional<string> readJinaExp(const ifstream& jinfile) {
	string exp;
	
	while (true) {
		exp->append(jinfile.getline());
		if ((jinFile.rdstate() & ifstream::failbit ) != 0 )
			break;
	};
	
	if (!exp.empty()) return exp;
}

string jina2c3(const string& jinaExp) {
	// words: alpha'numerics plus apostrophe, dot at start or colon at start or end
}

void generateCcFile(const string& jinfilePath) {
	/*
	type markers:
	Jina	C++
	T		unique_ptr<T>
	T$		shared_ptr<T>
	T&		const T&
	T!		T&
	
	name of borrow variables will be postfixed with the name of their owner
	the borrow tag of variables captured in a closure, will be prefixed with "PARENT_"
	
	to indicate that a type has a heap part: @tag("heap", 1)
	
	converters are implemented using c++ user'defined conversion
	https://cppreference.com/w/cpp/language/cast_operator.html
	
	generic types can be implemented using c3 generic modules
	for generic methods, use macros
	in generic methods, in certain situations, we can use this syntax sugar:
		m = { x ::I | ... }
	which is equivalent to:
		m[g::I] = { x :g | ... }
	if there is an interface constrain, use contract to implement it
	type inference from constructor args; is it implemented in C3?
		if not, implement them as a macro instead
	
	append "__" to identifiers that are C3 keywords
	
	literals
	numbers (words starting with a digit, or a "-" prepended digit):
	, remove apostrophes
	, if there is no point or "e", prepend with "(Int4)" cast
		otherwise prepend with "(Float2)" cast
	, if there is an "i" at the end: Complex[<type>] 0 <num-without-i>
	
	characters: 'a' '\n' '\x12'
	
	operators:
	a + b		a .add'op b
	a - b		a .sub'op b
	a * b		a .mul'op b
	a / b		a .div'op b
	a ^ b		a .exp b
	-a			a .neg
	a && b		a .and {b}
	a \\ b		a .or {b}
	a == b		a .is'equal b
	a >< b		a .is'not'equal b
	a > b		a .is'after b
	a >= b		a .is'after'or'equal b
	a < b		a .is'before b
	a <= b		a .is'before'or'equal b
	
	note that:
	a-b		;; a .sub'op b
	a - b	;; a .sub'op b
	a -b	;; a(b.neg)
	a -1	;; a(-1)
	
	enums are implemented using c3 enums and unions
	https://en.wikipedia.org/wiki/Tagged_union
	
	named tuples
	
	function: { | }
	replace with: fn () {}
	if the function is only made of one expression, replace with: fn () @inline {}
	if there are multiple "|", compile the body of the function to C3 switch
	
	overloaded methods:
	each method definition is soorounded by a "overload" macro
	use $switch, and $typeof to implement "overload" macro
	
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
	
	after running a message, if it returns false, remove the message from the list
	messages will be reapted until they return false
	
	a linked list containing tuples of actor's ID and memory address
	std::collections::LinkedList{Actor}* GLOBAL_actors_list;
	
	// if --no-evloop is not used
	GMainLoop eventloop = g_main_loop_new();
	https://wiki.libsdl.org/SDL3/README-main-functions
	https://wiki.libsdl.org/SDL3/SDL_Event
	https://wiki.libsdl.org/SDL3/CategoryAsyncIO
	https://lazyfoo.net/tutorials/SDL/33_file_reading_and_writing/index.php
	https://news.ycombinator.com/item?id=41471707
	https://www.actor-framework.org/
	
	actors list is partitioned: file handle 1, file handle 2, socket 1, socket 2, user interface
	each partition can wake up the eventloop to process the partition's messages
	
	the main loop only runs messages of UI actors (which are kept in a separate list); this means that:
	, a heavy computation that blocks its thread, can't make the UI lag
	, the UI remains responsive, even when the number of non'UI actors is extremely large
	the main loop runs messages of UI actors, and then polls (non'waiting) more events (glib2)
		if there is no more messages for UI actors, wait for events
	
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

generateJinaApiFile() {
	// distributed with compiled packages, for IDE hints
}

int main(int argc, char** argv) {
	if (argc == 0) {
		cout << "interactive Jina is not yet implemented";
		cou << "usage: jina <project_path> [c3c_options]";
		return;
	}
	
	io::Path! project_dir = io::Path::new(args[1]);
	if (catch excuse = project_dir) {
		io::printfn("directory \"%s\" does not exist", project_dir);
		return excuse?;
	} else if (! project_dir.is_dir()) {
		io::printfn("\"%s\" is not a directory", project_dir);
	}
	
	// if build target is "ELF freestanding" (kernel or embedded), link statically, and use --no-evloop
	
	foreach (pkg : io::Path.ls()) {
		// if --no-evloop is not used
		// spm import $gnunet_namespace glib
		
		// go through all files (recursively) and find ".p" files
		foreach (p_file : $(find .p)) {
			cat p_file
			
			// spm import <gnunet-namespace> <package-name>
		}
		
		// mkdir -p "$project_dir/.cache/jina/cc"
		
		/*
		find all .jin files (recursively), and if it's newer than the last generated .cc file,
			regenerate the .cc file
		number of parallel processes will be equal to the number of CPU cores,
			or the number of .jin files, either one which is smaller
		*/
		string cc_file_path = ;
		string cc_file_mtime = ;
		string jin_file_mtime = ;
		if (! jin_file_mtime || ! cc_file_mtime ||
			jin_file_mtime > cc_file_mtime ||
			cc_file_mtime > std::time:: // cc_file is from future!
		) {}
		
		// std.jin is compiled to C++ and imported to all the generated C++ files above
		
		/*
		search for .jin files in the project recursively
		when one is found, its containing directory, and the sibling directories containing .jin files,
			are the packages that must be compiled and published
		*/
		
		/*
		generate a build file, and then build
		https://ninja-build.org/
		args given to the build command:
			$clang_options
			"$project_dir/.cache/jina/cc"
		*/
	}
}
