/*
ref vars in a function will be kept in a list
if it is captured by an async funcion, it will be marked
at the end of the function unmarked variables will be freed explicitly

after compiling Jina to Vala:
valac --enable-experimental-non-null -d <output-dir> -o <output-file-name> <main-vala-file-path>
*/
