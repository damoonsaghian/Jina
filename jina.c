#include <stdio.h>
#include <string.h>

int main(int argc, char **argv) {
	char *project_dir = argv[1]
	
	if (project_dir == NULL) {
		printf("interactive Jina is not yet implemented");
		exit(EXIT_SUCCESS);
	}
	
	/*
	find changed Jina files in the project directory
	read them line by line
	enter different modes
	fill the table of identifiers and their types
	check fot type consistency of Jina code
	use libgirepository to check type consistency of external code
	generate C code in ".cache/jina"
	compile changed C files to object files:
		gcc -c "$project_dir"/.cache/jina/{changed,c,files}
	then link object files
		gcc -o program_name *.o
	*/
	
	exit(EXIT_SUCCESS);
}

/*
multi'threaded GUI (which GTK is not):
	container widget asks the children to stop drawing, and after receiving their reply, cleans their area,
	then sends the new areas to them to draw into
https://www.cairographics.org/threaded_animation_with_cairo/
*/
