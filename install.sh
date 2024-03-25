apt-get install lua5.4 lua-penlight gcc libglib2.0-dev libflint-dev

project_dir="$(dirname "$0")"

cp "$project_dir/jina.lua" /usr/local/bin/jina
chmod +x /usr/local/bin/jina

jina "$project_dir" -lglib2 -lflint
cp -r "$project_dir"/.cache/jina/out/libstd.jin.so /usr/local/lib/
