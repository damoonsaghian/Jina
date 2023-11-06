#!/bin/sh

if [ -z "$1" ]; then
	echo "interactive Jina is not yet implemented"
	exit 1
fi

<<'#'
make:
from .jina and .c files generate export files (that contains the type of exported definitions),
	and if not equal to the old one overwrite it: jina export ...
compile .jina files to .c files: jina compile ...
create header files from export files: jina header ...

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
#