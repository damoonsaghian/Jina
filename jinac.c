#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
https://www.geeksforgeeks.org/c-language-introduction
http://crasseux.com/books/ctutorial/
http://crasseux.com/books/ctutorial/The-form-of-a-C-program.html
https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html
https://www.learn-c.org/
https://en.wikibooks.org/wiki/C_Programming
https://en.wikibooks.org/wiki/A_Little_C_Primer/C_Quick_Reference
https://pdos.csail.mit.edu/6.828/2017/readings/pointers.pdf
https://viewsourcecode.org/snaptoken/kilo/
https://nullprogram.com/blog/2014/10/21/
https://nullprogram.com/blog/2015/02/17/
https://github.com/Snaipe/libcsptr
https://github.com/jeraymond/refcount

https://github.com/oz123/awesome-c
https://github.com/fragglet/c-algorithms
https://github.com/tboox/tbox
https://github.com/lanox2d/lanox2d

https://github.com/westes/flex
https://www.gnu.org/software/bison/
https://github.com/ianh/owl
http://re2c.org/index.html
https://github.com/orangeduck/mpc
*/

void generate_export_file(char *source_file_path) {}

void compile_jina2c(char *jina_file_path) {
	/*
	fill the table of identifiers (module identifiers and local ones) and their types
	check for type consistency
	compile to c
	*/
	
	// if a module is imported using gnunet or git, see if they are installed
	// and if not, ask the user to install them first, then exit with error
}

void generate_header_file(char *export_file_path) {}

int main(int argc, char **argv) {
	if (argv[1] == "export") {
		generate_export_file(argv[2]);
		return EXIT_SUCCESS;
	} else if (argv[1] == "compile") {
		compile_jina2c(argv[2]);
		return EXIT_SUCCESS;
	} else if (argv[1] == "header") {
		generate_header();
		return EXIT_SUCCESS;
	}
	
	printf("usage: jinac export|compile|header <file>")
	return EXIT_FAILURE;
}
