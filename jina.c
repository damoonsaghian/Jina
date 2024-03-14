/*
https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html
https://en.cppreference.com/w/c
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
*/

#include <stdlib.h>
#include <stdio.h>
#include <glib-2.0/glib.h>
#include <glib-2.0/glib-object.h>
#include <glib-2.0/gio/gio.h>

char generate_header_file(GFile* jina_file, GFile* h_file) {
	/*
	generate header and store it in a String var
	generate its hash
	if there is an old header file (remained from the last compilation),
	and it's not equal to the new one (compare their hashes), overwrite the old one
	otherwise just keep the old one, and return(0)
	
	also a .t file is generated which contains the type signature of all exported definitions
	*/
	
	GFileOutputStream* jina_file_stream = g_file_read(jina_file, NULL, NULL);
	GFileInputStream* h_file_stream = g_file_create(h_file, 0, NULL, NULL);
	
	g_object_unref(jina_file_stream);
	g_object_unref(h_file_stream);
	
	return(1);
}

char* generate_c_file(GFile* jina_file, GFile* c_file) {
	// a comma separatedlist of paths of imported modules
	char* imported_modules_paths;
	
	// fill the table of module identifiers and their types
	// https://docs.gtk.org/glib/struct.HashTable.html
	// check for type consistency in the module, and with (cached) .t files
	// compile to c
	
	/*
	#include <stdlib.h>
	#include <glib-2.0/glib.h>
	; https://packages.debian.org/bookworm/amd64/libglib2.0-dev/filelist
	
	int main(int argc, char* argv[]) {}
	
	words: alpha'numerics plus apostrophe, dot or colon at the start or end
	if the second word is an operator (=, +, .add), find the type of first word, then build the function's name
	otherwise use the first word as the function's name
	if it's a definition, add it to the table of local definition which contains their types
	*/
		
	/*
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
	*/
	
	GFileOutputStream* jina_file_stream = g_file_read(jina_file, NULL, NULL);
	GFileInputStream* c_file_stream = g_file_create(c_file, 0, NULL, NULL);
	
	g_object_unref(jina_file_stream);
	g_object_unref(c_file_stream);
	
	return(imported_modules_paths);
}

int main(int argc, char* argv[]) {
	if (argc == 1) {
		printf("interactive Jina is not yet implemented\n");
		exit(EXIT_FAILURE);
	}
	if (argc > 2) {
		printf("usage: jina <project_path>\n");
		exit(EXIT_FAILURE);
	}
	
	GFile* project_dir = g_file_new_for_path(argv[1]);
	if (g_file_query_file_type(project_dir, 0, NULL) != G_FILE_TYPE_DIRECTORY) {
		printf("there is no directory at \"%s\"\n", g_file_peek_path(project_dir));
		exit(EXIT_FAILURE);
	}
	GFile* src_dir = g_file_get_child(project_dir, "src");
	if (g_file_query_file_type(src_dir, 0, NULL) != G_FILE_TYPE_DIRECTORY) {
		src_dir = g_file_new_for_path(argv[1]);
	}
	GFile* c_dir = g_file_new_build_filename(g_file_peek_path(project_dir), ".cache", "jina", "c");
	if (
		!g_file_make_directory_with_parents(c_dir) &&
		g_file_query_file_type(c_dir, 0, NULL) != G_FILE_TYPE_DIRECTORY
	) {
		printf("can't create \"%s\" directory\n", g_file_peek_path(c_dir));
		exit(EXIT_FAILURE);
	}
	GFile* o_dir = g_file_new_build_filename(g_file_peek_path(project_dir), ".cache", "jina", "o");
	if(
		!g_file_make_directory_with_parents(o_dir) &&
		!g_file_query_file_type(o_dir, 0, NULL) != G_FILE_TYPE_DIRECTORY
	) {
		printf("can't create \"%s\" directory\n", g_file_peek_path(o_dir));
		exit(EXIT_FAILURE);
	}
	
	GPtrArray* modules_with_changed_exports = g_ptr_array_new();
	
	// go through all files in the project directory (or "project_dir/src" if it exists)
	// generate header files from .jin files
	// and add packages mensioned in .p files
	GQueue* dir_enums_queue = g_queue_new();
	g_queue_push_tail(
		dir_enums_queue,
		g_file_enumerate_children(src_dir, G_FILE_ATTRIBUTE_STANDARD_NAME, 0, NULL, NULL)
	);
	while (1) {
		GFileEnumerator* dir_enum = g_queue_peek_tail(dir_enums_queue);
		GFileInfo* entry_info = g_file_enumerator_next_file(dir_enum);
		if (entry_info == NULL) {
			g_object_unref(entry_info);
			g_object_unref(dir_enum);
			g_queue_pop_tail(dir_enums_queue);
			if (g_queue_get_length(dir_enums_queue) == 0) { break; } else { continue; }
		}
		GFile* entry = g_file_enumerator_get_child(dir_enum, entry_info);
		g_object_unref(entry_info);
		
		if (g_file_query_file_type(entry, 0, NULL) == G_FILE_TYPE_DIRECTORY) {
			q_queue_push_tail(
				dir_enums_queue,
				g_file_enumerate_children(entry, G_FILE_ATTRIBUTE_STANDARD_NAME, 0, NULL, NULL)
			);
		} else if (g_str_has_suffix(g_file_peek_path(entry), ".jin")) {
			GString* relative_path = g_string_new_take(
				g_file_get_relative_path(src_dir, g_file_peek_path(entry))
			);
			g_string_truncate(relative_path, relative_path->len - 4); // remove .jin extension
			g_string_append(relative_path, ".h");
			GFile* h_file = g_file_resolve_relative_path(c_dir, relative_path);
			
			if (generate_header_file(entry, h_file) == 1)
				g_ptr_array_append(modules_with_changed_exports, g_file_peek_path(entry));
			
			g_object_unref(relative_path);
			g_object_unref(h_file);
			g_object_unref(entry);
		} else if (g_str_has_suffix(g_file_peek_path(entry), ".p")) {
			// if gnunet or git is needed to add a package, and they are not installed on the system,
			// ask the user to install them first, then exit with error
			
			// packages will be downloaded to ~/.local/share/jina/packages/package-name
			// after compiling the package:
			// ln -s ~/.local/share/jina/packages/package-name/.cache/jina/so $project_dir/.cahce/jina/package-name.so
			// ln -s ~/.local/share/jina/packages/package-name/.cache/jina/c $project_dir/.cahce/jina/c/package-name
			
			g_object_unref(entry);
		}
	}
	
	GPtrArray* modules_with_changed_imports = g_ptr_array_new();
	
	// again go through all files, and compile (newly changed) .jin files to .c files
	g_queue_push_tail(
		dir_enums_queue,
		g_file_enumerate_children(src_dir, G_FILE_ATTRIBUTE_STANDARD_NAME, 0, NULL, NULL)
	);
	while (1) {
		GFileEnumerator* dir_enum = g_queue_peek_tail(dir_enums_queue);
		GFileInfo* entry_info = g_file_enumerator_next_file(dir_enum);
		if (entry_info == NULL) {
			g_object_unref(entry_info);
			g_object_unref(dir_enum);
			g_queue_pop_tail(dir_enums_queue);
			if (g_queue_get_length(dir_enums_queue) == 0) { break; } else { continue; }
		}
		GFile* entry = g_file_enumerator_get_child(dir_enum, entry_info);
		g_object_unref(entry_info);
		
		if (g_file_query_file_type(entry, 0, NULL) == G_FILE_TYPE_DIRECTORY) {
			q_queue_push_tail(
				dir_enums_queue,
				g_file_enumerate_children(entry, G_FILE_ATTRIBUTE_STANDARD_NAME, 0, NULL, NULL)
			);
		} else if (g_str_has_suffix(g_file_peek_path(entry), ".jin")) {
			GString* relative_path = g_string_new_take(
				g_file_get_relative_path(src_dir, g_file_peek_path(entry))
			);
			g_string_truncate(relative_path, relative_path->len - 4); // remove .jin extension
			g_string_append(relative_path, ".c");
			GFile* c_file = g_file_resolve_relative_path(c_dir, relative_path);
			
			char* imported_modules = generate_c_file(entry, c_file);
			/*
			split imported_modules
			if an imported module is in modules_with_changed_exports,
				add g_file_peek_path(entry) to modules_with_changed_imports
			*/
			
			GFileInfo* jina_file_info = g_file_query_info(entry, FILE_ATTRIBUTE_TIME_MODIFIED, 0, NULL, NULL);
			GDateTime* jina_file_mtime = g_file_info_get_modification_date_time(jina_file_info);
			g_object_unref(jina_file_info);
			
			GFileInfo* c_file_info = g_file_query_info(c_file, FILE_ATTRIBUTE_TIME_MODIFIED, 0, NULL, NULL);
			GDateTime* c_file_mtime = g_file_info_get_modification_date_time(c_file_info);
			g_object_unref(c_file_info);
			
			if (
				jina_file_mtime == NULL ||
				c_file_mtime == NULL ||
				g_date_time_compare(jina_file_mtime, c_file_mtime) > 0
			) {
				generate_c_file(entry, c_file);
			}
			
			g_object_unref(jina_file_mtime);
			g_object_unref(c_file_mtime);
			g_object_unref(relative_path);
			g_object_unref(c_file);
			g_object_unref(entry);
		}
	}
	
	/*
	TODO: use multiple threads to generate headers and to compile Jina to C
	number of spawn threads will be equal to the number of CPU cores,
		or the number of Jina files, either one which is smaller
	*/
	
	// the created binary will at least need glib2 and flint dynamic libraries
	char* dlinks = "glib2,flint";
	
	// go through all files in the directory containing the generated C files
	g_queue_push_tail(
		dir_enums_queue,
		g_file_enumerate_children(c_dir, G_FILE_ATTRIBUTE_STANDARD_NAME, 0, NULL, NULL)
	);
	while (1) {
	}
	dir.getallfiles(c_dir_path, "%.c$"):foreach(function (c_file_path)
		local relpath_wo_ext, _ = path.splitext(
			path.relpath(c_file_path, c_dir_path)
		)
		
		// if for the C file, there is no corresponding jina file, delete it and its header file
		local jina_file_path = path.join(src_dir_path, relpath_wo_ext..".jin")
		if not path.isfile(jina_file_path) then
			os.remove(c_file_path)
			os.remove(path.join(c_dir_path, relpath_wo_ext)..".h")
			return
		end
		
		local o_file_name = relpath_wo_ext:gsub(path.sep, "__") .. ".o"
		local o_file_path = path.join(o_dir_path, o_file_name)
		local o_file_mtime = path.getmtime(o_file_path)
		
		local mtimes = { path.getmtime(c_file_path) }
		// find the modification times of all included files, and add them to the list
		// also add the name of all system libs to dlinks
		
		// recompile if:
		// , the corresponding jina file is in modules_with_changed_imports
		// , or the modification time of the C file is newer than the object file
		for _, mtime in ipairs(mtimes) do
			if mtime > o_file_mtime then
				if path.isfile(path.join(src_dir_path, "0.jin")) then
					os.execute("gcc -Wall -Wextra -Wpedantic -c "..c_file_path.." -o "..o_file_path)
				else
					os.execute("gcc -Wall -Wextra -Wpedantic -fPIC -c "..c_file_path.." -o "..o_file_path)
				end
				break
			end
		end
	end)
	
	// link object files
	if (path.isfile(path.join(src_dir_path, "0.jin"))) {
		local executable_path = path.join(project_path, ".cache/jina/0")
		os.execute("gcc "..o_dir_path.."/*.o -l{"..dlinks.."} -o "..executable_path)
		os.execute("LD_LIBRARY_PATH=. "..executable_path)
	} else {
		os.execute("gcc -shared "..o_dir_path.."/*.o -l{"..dlinks.."} -o "..
			path.join(project_path, ".cache/jina/so")
		)
		
		// link object files in "projict_dir/test" directory, and run the created executable
		// LD_LIBRARY_PATH=.
	}
	
	g_queue_free(dir_enums_queue);
	g_object_unref(project_dir);
	g_object_unref(src_dir);
	g_object_unref(c_dir);
	g_object_unref(o_dir);
}
