apt-get install lua5.3 lua-filesystem gcc libevent-dev

project_dir="$(dirname "$0")"

cp "$project_dir/jina.lua" /usr/local/bin/jina
chmod +x /usr/local/bin/jina

mkdir -p /usr/local/lib/jina/
cp -r "$project_dir"/std/* /usr/local/lib/jina/
