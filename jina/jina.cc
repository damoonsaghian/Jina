#include <iostream>
#include <optional>
#include <string>

using namespace std;

optional<string> readJinaExp(const ifstream& jinfile) {
	string exp;
	
	while (true) {
		exp.append(jinfile.getline());
		if ((jinFile.rdstate() & ifstream::failbit ) != 0 )
			break;
	};
	
	if (!exp.empty()) return exp;
}

string jina2cc(const string& jinaExp) {
	// words: alpha'numerics plus apostrophe, dot at start or colon at start or end
}

void generateCcFile(const string& jinfilePath) {
	/*
	type markers:
	Jina	C++
	T		T (with RAII for heap part)
	T$		shared_ptr<T>
	T&		const T&
	T!		T&
	
	C++ already uses move automatically when copying from an object it knows will never be used again,
		such as a temporary object or a local variable being returned or thrown from a function
	this is achieved through move constructors and move assignment operators
	
	name of borrow variables will be postfixed with the name of their owner
	the borrow tag of variables captured in a closure, will be prefixed with "PARENT_"
	https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2024/p3444r0.html
	https://github.com/ladroid/CppBorrowChecker
	
	converters are implemented using c++ user'defined conversion
	https://cppreference.com/w/cpp/language/cast_operator.html
	
	c++ dynamic linking templates
	
	c++ auto header file
	https://hackaday.com/2021/11/08/linux-fu-automatic-header-file-generation/
	https://softwareengineering.stackexchange.com/questions/35375/what-to-do-if-i-hate-c-header-files
	https://www.hwaci.com/sw/mkhdr/
	
	in generic methods, in certain situations, we can use this syntax sugar:
		m = { x ::I | ... }
	which is equivalent to:
		m[g::I] = { x :g | ... }
	
	append "__" to identifiers that are C++ keywords
	
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
	
	enums are implemented using C++ variants and enum classes
	
	https://en.cppreference.com/w/cpp/utility/tuple.html
	
	named tuples
	https://stackoverflow.com/questions/13065166/c11-tagged-tuple
	https://github.com/erez-strauss/named_tuples
	named arguments
	https://www.reddit.com/r/cpp/comments/l4nyhv/c23_named_parameters_design_notes/
	https://en.wikipedia.org/wiki/Named_parameter
	https://en.wikibooks.org/wiki/More_C%2B%2B_Idioms/Named_Parameter
	https://pdimov.github.io/blog/2020/09/07/named-parameters-in-c20/
	
	https://www.reddit.com/r/cpp/comments/mthcgb/universal_function_call_syntax_in_c20/
	https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2021/p0847r7.html
	
	function: { | }
	replace with: fn () {}
	if the function is only made of one expression, replace with: fn () @inline {}
	if there are multiple "|", compile the body of the function to C3 switch
	
	stacks are designed for sync computation
	using a lot of them as async cores (stackful green threads) is inefficient
	
	after calling the init function, create a fixed number of threads (as many as CPU cores),
		and then run the main loop
	each thread runs a loop that processes the messages
	after each loop, if there are no messages left, it goes to sleep (sigwait)
	when a message is registered, a signal will be sent to all threads to wake up the slept ones
	use Qt eventloop if --no-evloop is not used
	https://www.actor-framework.org/
	after running a message, if it returns false, remove the message from the list
	messages will be reapted until they return false
	a linked list containing tuples of actor's ID and memory address
	GLOBAL_actors_list
	use mutexes to hold the list of actors and their message queues
	actors list is partitioned: file handle 1, file handle 2, socket 1, socket 2, user interface
	each partition can wake up the eventloop to process the partition's messages
	
	the main loop only runs messages of UI actors (which are kept in a separate list); this means that:
	, a heavy computation that blocks its thread, can't make the UI lag
	, the UI remains responsive, even when the number of non'UI actors is extremely large
	the main loop runs messages of UI actors, and then polls (non'waiting) more events
		if there is no more messages for UI actors, wait for events
	*/
	
	// open jinFile from jinFilePath
	// create ccFile
	
	string jinaExp;
	string ccExp;
	do {
		jinaExp = readJinaExp(&jinFilePath);
		ccExp = jina2cc(jinaExp);
		ccFile.write(ccExp);
	};
}

generateJinaApiFile() {
	// distributed with compiled packages, for IDE hints
}

int main(int argc, char** argv) {
	if (argc == 0) {
		cout << "interactive Jina is not yet implemented";
		cout << "usage: jina <project_path> [c3c_options]";
		return;
	};
	
	// projectDir from args[1]
	// printfn("directory \"%s\" does not exist", projectDir);
	// printfn("\"%s\" is not a directory", project_dir);
	
	// if build target is "ELF freestanding" (kernel or embedded), link statically, and use --no-evloop
	
	// if --no-evloop is not used
	// spm import $gnunet_namespace qt
	
	// go through all files (recursively) and find ".p" files, and for each:
	// read the file and obtain: <gnunet-namespace> <package-name>
	// spm import <gnunet-namespace> <package-name>
	
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
	
	// jina-std is compiled to C++ and imported to all the generated C++ files above
	
	/*
	generate a build file, and then build
	https://ninja-build.org/
	args given to the build command:
		$clang_options
		"$project_dir/.cache/jina/cc"
	*/
}
