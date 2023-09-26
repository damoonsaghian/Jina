apt-get install gcc libgirepository1.0-dev gnunet

project_dir="$(dirname "$0")"
mkdir -p "$project_dir/.cache/gcc"

gcc -o "$project_dir/.cache/gcc/jina" "$project_dir/src/jina.c"
cp "$project_dir/.cache/gcc/jina" /usr/local/bin/
