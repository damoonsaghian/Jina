apt-get install gcc
cd "$(dirname "$0")"
mkdir -p ".cache/gcc"
gcc ".cache/gcc"
cp "$project_dir/.cache/gcc/jina" /usr/local/bin/
