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

note that record types are not compiled to c structs
records are implemented as multiple variables

functions are compiled to c functions with only one arg, which is a struct
adding members to the end of structs do not change ABI

there is a one to one relation between API and ABI
API change means ABI change; API invarience means ABI invarience
so for recompiling an object file, we just need to track the corresponding .c file,
	and not all the included .h files

https://github.com/Microsoft/mimalloc
libmimalloc-dev
*/

#include <stdlib.h>
#include <stdio.h>
#include <glib-2.0/glib.h>
#include <glib-2.0/glib-object.h>
#include <glib-2.0/gio/gio.h>

#include "gen_header.c"
#include "gen_c.c"

void compile_jina(char* dir_path) {
	// go through all files in the dir_path, recursively, including packages included using .p files
	// generate header files from .jin files
	GString* dlinks = g_string_new("glib2,flint");
	GQueue* dir_enums_queue = g_queue_new();
	GFileEnumerator* dir_enum;
	GFileInfo* entry_info;
	GFile* entry;
	GString* relative_path;
	GFile* h_file;
	GFile* package_dir;
	g_queue_push_tail(
		dir_enums_queue,
		g_file_enumerate_children(src_dir, G_FILE_ATTRIBUTE_STANDARD_NAME, 0, NULL, NULL)
	);
	while (1) {
		dir_enum = g_queue_peek_tail(dir_enums_queue);
		entry_info = g_file_enumerator_next_file(dir_enum);
		if (entry_info == NULL) {
			g_queue_pop_tail(dir_enums_queue);
			if (g_queue_get_length(dir_enums_queue) == 0) { break; } else { continue; }
		}
		entry = g_file_enumerator_get_child(dir_enum, entry_info);
		
		if (g_file_query_file_type(entry, 0, NULL) == G_FILE_TYPE_DIRECTORY) {
			q_queue_push_tail(
				dir_enums_queue,
				g_file_enumerate_children(entry, G_FILE_ATTRIBUTE_STANDARD_NAME, 0, NULL, NULL)
			);
		} else if (g_str_has_suffix(g_file_peek_path(entry), ".jin")) {
			relative_path = g_string_new_take(
				g_file_get_relative_path(src_dir, g_file_peek_path(entry))
			);
			g_string_truncate(relative_path, relative_path->len - 4); // remove .jin extension
			g_string_append(relative_path, ".h");
			h_file = g_file_resolve_relative_path(h_dir, relative_path);
			
			jina_file_info = g_file_query_info(entry, FILE_ATTRIBUTE_TIME_MODIFIED, 0, NULL, NULL);
			jina_file_mtime = g_file_info_get_modification_date_time(jina_file_info);
			
			h_file_info = g_file_query_info(h_file, FILE_ATTRIBUTE_TIME_MODIFIED, 0, NULL, NULL);
			h_file_mtime = g_file_info_get_modification_date_time(h_file_info);
			
			if (
				jina_file_mtime == NULL ||
				h_file_mtime == NULL ||
				g_date_time_compare(jina_file_mtime, h_file_mtime) > 0
			) {
				generate_header_file(entry, h_file);
			}
		} else if (g_str_has_suffix(g_file_peek_path(entry), ".p")) {
			// if gnunet or git is needed to add a package, and they are not installed on the system,
			// ask the user to install them first, then exit with error
			
			// download the package to ~/.local/share/jina/packages/package-name
			package_dir = ;
			
			/*
			if the package protocol is "gnunet" or "git", and it needs download/update,
				or the compiled lib does not exist
			*/
			if () q_queue_push_tail(
				dir_enums_queue,
				g_file_enumerate_children(package_dir, G_FILE_ATTRIBUTE_STANDARD_NAME, 0, NULL, NULL)
			);
			
			/*
			add the path of the lib compiled from the package to dlinks,
				except for packages added with "lib" protocol
			ln -s ~/.local/share/jina/packages/package-name/.cache/jina/so \
				$project_dir/.cahce/jina/lib/package-name.so
			*/
		}
	}
	
	g_object_unref(h_file);
	
	// again go through all files, and compile (newly changed) .jin files to .c files
	GFile* c_file;
	GFileInfo* jina_file_info;
	GDateTime* jina_file_mtime;
	GFileInfo* c_file_info;
	GDateTime* c_file_mtime;
	g_queue_push_tail(
		dir_enums_queue,
		g_file_enumerate_children(src_dir, G_FILE_ATTRIBUTE_STANDARD_NAME, 0, NULL, NULL)
	);
	while (1) {
		dir_enum = g_queue_peek_tail(dir_enums_queue);
		entry_info = g_file_enumerator_next_file(dir_enum);
		if (entry_info == NULL) {
			g_queue_pop_tail(dir_enums_queue);
			if (g_queue_get_length(dir_enums_queue) == 0) { break; } else { continue; }
		}
		entry = g_file_enumerator_get_child(dir_enum, entry_info);
		
		if (g_file_query_file_type(entry, 0, NULL) == G_FILE_TYPE_DIRECTORY) {
			q_queue_push_tail(
				dir_enums_queue,
				g_file_enumerate_children(entry, G_FILE_ATTRIBUTE_STANDARD_NAME, 0, NULL, NULL)
			);
		} else if (g_str_has_suffix(g_file_peek_path(entry), ".jin")) {
			relative_path = g_string_new_take(
				g_file_get_relative_path(src_dir, g_file_peek_path(entry))
			);
			g_string_truncate(relative_path, relative_path->len - 4); // remove .jin extension
			g_string_append(relative_path, ".c");
			g_string_replace(relative_path, G_DIR_SEPARATOR_S, "__");
			c_file = g_file_resolve_relative_path(c_dir, relative_path);
			
			jina_file_info = g_file_query_info(entry, FILE_ATTRIBUTE_TIME_MODIFIED, 0, NULL, NULL);
			jina_file_mtime = g_file_info_get_modification_date_time(jina_file_info);
			
			c_file_info = g_file_query_info(c_file, FILE_ATTRIBUTE_TIME_MODIFIED, 0, NULL, NULL);
			c_file_mtime = g_file_info_get_modification_date_time(c_file_info);
			
			if (
				jina_file_mtime == NULL ||
				c_file_mtime == NULL ||
				g_date_time_compare(jina_file_mtime, c_file_mtime) > 0
			) {
				generate_c_file(entry, c_file);
			}
		} else if (g_str_has_suffix(g_file_peek_path(entry), ".p")) {
		}
	}
	
	/*
	TODO: use multiple threads to generate headers and to compile Jina to C
	number of spawn threads will be equal to the number of CPU cores,
		or the number of Jina files, either one which is smaller
	*/
	
	g_object_unref(entry);
	g_object_unref(entry_info);
	g_object_unref(jina_file_info);
	g_object_unref(jina_file_mtime);
	g_queue_free(dir_enums_queue);
}

void compile_c(char* dir_path) {
	// go through all files in the directory containing the generated C files
	GFileInfo* o_file_info;
	GDateTime* o_file_mtime;
	dir_enum = g_file_enumerate_children(c_dir, G_FILE_ATTRIBUTE_STANDARD_NAME, 0, NULL, NULL)
	while (1) {
		c_file_info = g_file_enumerator_next_file(dir_enum, NULL, NULL);
		if (entry_info == NULL) break;
		c_file = g_file_enumerator_get_child(dir_enum, c_file_info);
		c_file_mtime = g_file_info_get_modification_date_time(c_file_info);
		
		relative_path = g_string_new_take(g_file_basename(entry_info));
		g_string_truncate(relative_path, relative_path->len - 2); // remove .c extension
		g_string_append(entry_name, ".o");
		
		// if for the C file, there is no corresponding jina file, delete it and its header file
		jina_file_path = path.join(src_dir_path, relpath_wo_ext..".jin")
		if (!path.isfile(jina_file_path)) {
			g_file_remove(c_file_path);
			g_file_remove(path.join(c_dir_path, relpath_wo_ext)..".h");
			continue;
		}
		
		o_file = g_file_resolve_relative_path(o_dir, relative_path);
		GFileInfo* o_file_info = g_file_query_info(o_file, FILE_ATTRIBUTE_TIME_MODIFIED, 0, NULL, NULL);
		GDateTime* o_file_mtime = g_file_info_get_modification_date_time(o_file_info);
		
		if (
			c_file_mtime == NULL ||
			o_file_mtime == NULL ||
			g_date_time_compare(c_file_mtime, o_file_mtime) > 0
		) {
			// argv[2] can contain gcc options
			
			if (path.isfile(path.join(src_dir_path, "0.jin"))) {
				os.execute("gcc -Wall -Wextra -Wpedantic -c %s -o %s", c_file_path, o_file_path);
			} else {
				os.execute("gcc -Wall -Wextra -Wpedantic -fPIC -c %s -o %s", c_file_path, o_file_path);
			}
		}
	}
	
	// link object files
	if (path.isfile(path.join(src_dir_path, "0.jin"))) {
		executable_path = path.join(project_path, ".cache/jina/0");
		os.execute("gcc %s/*.o -l{%s} -o %s", o_dir_path, dlinks, executable_path);
		os.execute("LD_LIBRARY_PATH='%s/.cache/jina/lib' '%s'",
			g_file_peek_path(project_dir),
			executable_path
		);
	} else {
		os.execute("gcc -shared %s/*.o -l{%s} -o %s",
			o_dir_path,
			dlinks,
			path.join(project_path, ".cache/jina/so")
		);
	}
	
	g_object_unref(dlinks);
	g_object_unref(c_file);
	g_object_unref(c_file_info);
	g_object_unref(c_file_mtime);
	g_object_unref(o_file_info);
	g_object_unref(o_file_mtime);
	g_object_unref(dir_enum);
	g_object_unref(relative_path);
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
		printf("there is no \"src\" directory in \"%s\"\n", g_file_peek_path(project_dir));
		exit(EXIT_FAILURE);
	}
	GFile* test_dir = g_file_get_child(project_dir, "test");
	GFile* c_dir = g_file_new_build_filename(g_file_peek_path(project_dir), ".cache", "jina", "c");
	if (
		!g_file_make_directory_with_parents(c_dir) &&
		g_file_query_file_type(c_dir, 0, NULL) != G_FILE_TYPE_DIRECTORY
	) {
		printf("can't create \"%s\" directory\n", g_file_peek_path(c_dir));
		exit(EXIT_FAILURE);
	}
	GFile* h_dir = g_file_new_build_filename(g_file_peek_path(project_dir), ".cache", "jina", "h");
	if (
		!g_file_make_directory_with_parents(h_dir) &&
		g_file_query_file_type(h_dir, 0, NULL) != G_FILE_TYPE_DIRECTORY
	) {
		printf("can't create \"%s\" directory\n", g_file_peek_path(h_dir));
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
	
	compile_jina(src_dir);
	compile_c(c_dir);
	// compile_c(package_dir) for all packages, recursively
	
	if () {
		compile_jina(test_dir);
		compile_c(test_c_dir);
		// compile_c(package_dir) for all packages, recursively
		// run test program
	}
	
	g_object_unref(project_dir);
	g_object_unref(src_dir);
	g_object_unref(c_dir);
	g_object_unref(o_dir);
}
