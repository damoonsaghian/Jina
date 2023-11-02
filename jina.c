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

gnu make

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

int main(int argc, char **argv) {
	char *project_dir = argv[1]
	
	if (project_dir == NULL) {
		// tcc compiler
		printf("interactive Jina is not yet implemented");
		return EXIT_SUCCESS;
	}
	
	/*
	fill the table of identifiers (module identifiers and local ones) and their types
		even for c files
	check for type consistency
	
	make:
	system("make")
	gcc -c \"$project_dir\"/.cache/jina/*.c
	to create dynamic libs:
		gcc -c -fPIC \"$project_dir\"/.cache/jina/*.c
	linking object files:
	, for programs (there is a file named "0.jina" in the project directory):
		gcc -o \"$project_dir\"/.cache/jina/bin \"$project_dir\"/.cache/jina/*.o
	, for libraries:
		gcc -Wl,-soname,lib.so.$ver_maj -o \"$project_dir\"/.cache/jina/lib \"$project_dir\"/.cache/jina/*.o
		cp \"$project_dir\"/.cache/jina/libo /usr/local/lib/lib${lib_name}.so.${ver_maj}.${ver_min}
		ln -s /usr/local/lib/libjina.so.${ver_maj}.${ver_min} /usr/local/lib/libjina.so.$ver_maj
		ln -s /usr/local/lib/libjina.so.$ver_maj /usr/local/lib/libjina.so
	*/
	
	// if a module is imported using gnunet or git, see if they are installed
	// and if not, ask the user to install them first, then exit with error
	
	return EXIT_SUCCESS;
}
