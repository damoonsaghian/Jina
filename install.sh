apt-get install gcc
cd "$(dirname "$0")"
mkdir -p ".cache/gcc"
gcc -o .cache/gcc/jina src/*.c
cp "$project_dir/.cache/gcc/jina" /usr/local/bin/
