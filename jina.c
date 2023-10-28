#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
	char *project_dir = argv[1]
	
	if (project_dir == NULL) {
		// tcc compiler
		printf("interactive Jina is not yet implemented");
		return EXIT_SUCCESS;
	}
	
	// find all the jina files in project_dir, that have changed since the last compilation
	char **source_files =
	
	/*
	fill the table of identifiers (module identifiers and local ones) and their types
		even for c files
	check for type consistency
	remove all ".cache/jina/*.c" files
	move all "*.o" files to ".cache/jina/objects" directory
		for each unchanged jina file, move the corresponding object file to ".cache/jina" directory
		remove ".cache/jina/objects" directory
	for each changed Jina file, generate a C file in ".cache/jina"
	compile C files to object files:
		system("gcc -c \"$project_dir\"/.cache/jina/*.c")
	for libs:
		system("gcc -c -fPIC \"$project_dir\"/.cache/jina/*.c")
	then link object files:
	, for programs (there is a file named "0.jina" in the project directory):
		system("gcc -o \"$project_dir\"/.cache/jina/bin \"$project_dir\"/.cache/jina/*.o")
	, for libraries:
		system("gcc -Wl,-soname,lib.so.$ver_maj -o \"$project_dir\"/.cache/jina/lib \"$project_dir\"/.cache/jina/*.o")
		system("cp \"$project_dir\"/.cache/jina/libo /usr/local/lib/lib${lib_name}.so.${ver_maj}.${ver_min}")
		system("ln -s /usr/local/lib/libjina.so.${ver_maj}.${ver_min} /usr/local/lib/libjina.so.$ver_maj")
		system("ln -s /usr/local/lib/libjina.so.$ver_maj /usr/local/lib/libjina.so")
	*/
	
	// if a module is imported using gnunet or git, see if they are installed
	// and if not, ask the user to install them first, then exit with error
	
	return EXIT_SUCCESS;
}
