#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
	char *project_dir = argv[1]
	
	if (project_dir == NULL) {
		printf("interactive Jina is not yet implemented");
		return EXIT_SUCCESS;
	}
	
	// find all the jina files in project_dir, that have changed since the last compilation
	char **source_files =
	
	/*
	fill the table of identifiers (module identifiers and local ones) and their types
	check for type consistency of Jina code
	use libgirepository to check type consistency with external code
	remove all "*.c" files
	move all "*.o" files to ".cache/jina/objects" directory
		for each unchanged jina file, move the corresponding object file to ".cache/jina" directory
		remove ".cache/jina/objects" directory
	generate C code in ".cache/jina"
	compile C files to object files:
		system("gcc -c \"$project_dir\"/.cache/jina/{all,c,files}")
	then link object files
		system("gcc -o program_name *.o")
	*/
	
	/*
	for a class "ClassName" in a Jina file module "mod.jina" create these two files:
	, a header file named "mod-class-name.h":
		#pragma once
		#include <glib-object.h>
		G_BEGIN_DECLS
		
		// type declaration
		#define MOD_TYPE_CLASS_NAME mod_class_name_get_type()
		G_DECLARE_FINAL_TYPE (ModeClassName, mode_class_name, MOD, CLASS_NAME, GObject)
		
		// method definitions
		ModClassName *mod_class_name_new (void);
		
		G_END_DECLS
	, a file named "mod-class-name.c":
		#include "mod-class-name.h"
		
		struct _ModClassName {
			GObject parent_instance;
			// other members, including private data
		};
		
		G_DEFINE_TYPE (ModClassName, mode_class_name, G_TYPE_OBJECT)
	*/
	
	return EXIT_SUCCESS;
}
