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
		system("gcc -o \"$project_dir\"/.cache/jina/bin *.o")
	*/
	
	// if a module is imported using gnunet or git, see if they are installed
	// and if not, ask the user to install them first, then exit with error
	
	return EXIT_SUCCESS;
}
