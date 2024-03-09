apt-get install gcc libglib2.0-dev libflint-dev

project_dir="$(dirname "$0")"

gcc -Wall -Wextra -Wpedantic -lglib-2.0 "$project_dir/*.c" -o "$project_dir/.cache/gcc/jina"
cp "$project_dir/.cache/gcc/jina" /usr/local/bin/jina

mkdir -p /usr/local/lib/jina/
cp -r "$project_dir"/std/* /usr/local/lib/jina/
