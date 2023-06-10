/*
to prevent unnecessary reference counting, all variable accesses, except variable capture by an async funcion,
	will be marked with "unowned"
	note that function parameters are unowned by default

after compiling Jina to Vala:
valac --enable-experimental-non-null -d <output-dir> -o <output-file-name> <main-vala-file-path>
*/
