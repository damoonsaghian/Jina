apt-get install gcc make cthreadpool-dev

project_dir="$(dirname "$0")"
mkdir -p "$project_dir/.cache/gcc"

gcc -o "$project_dir/.cache/gcc/jinac" "$project_dir/jinac.c"
cp "$project_dir/.cache/gcc/jinac" /usr/local/bin/

mkdir -p /usr/local/lib/jina/
cp "$project_dir"/std/* /usr/local/lib/jina/

cp "$project_dir/jina.sh" /usr/local/bin/jina
chmod +x /usr/local/bin/jina
