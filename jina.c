#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
https://pdos.csail.mit.edu/6.828/2017/readings/pointers.pdf
http://crasseux.com/books/ctutorial/
http://crasseux.com/books/ctutorial/The-form-of-a-C-program.html#The%20form%20of%20a%20C%20program
https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html#Data-Types
https://www.learn-c.org/
https://en.wikibooks.org/wiki/C_Programming
https://en.wikibooks.org/wiki/A_Little_C_Primer/C_Character_Class_Test_Library
https://en.wikibooks.org/wiki/A_Little_C_Primer/C_File-IO_Through_Library_Functions
https://en.wikibooks.org/wiki/A_Little_C_Primer/C_Quick_Reference
https://viewsourcecode.org/snaptoken/kilo/
https://github.com/oz123/awesome-c#data-structures
https://www.geeksforgeeks.org/dynamic-array-in-c/
https://nullprogram.com/blog/2014/10/21/
https://nullprogram.com/blog/2015/02/17/
https://aardappel.github.io/lobster/memory_management.html
https://github.com/Snaipe/libcsptr
https://github.com/jeraymond/refcount
https://github.com/taylordotfish/autoheaders
*/

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
	check for type consistency of Jina code
	type consistency between modules, as well as between Jina and C code, will be checked too
	remove all "*.c" files
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
