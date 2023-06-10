/*
to prevent ref counting, all variables, unless they are captured by an async funcion,
	will be defined as owned, and subsequent access would be marked as unowned

after compiling Jina to Vala:
valac --enable-experimental-non-null -d <output-dir> -o <output-file-name> <main-vala-file-path>
*/
