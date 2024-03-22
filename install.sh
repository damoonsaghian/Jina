apt-get install lua5.4 lua-penlight gcc libglib2.0-dev libflint-dev

project_dir="$(dirname "$0")"

cp "$project_dir/jina.lua" /usr/local/bin/jina
chmod +x /usr/local/bin/jina

mkdir -p /usr/local/lib/jina/
cp -r "$project_dir"/std/* /usr/local/lib/jina/
