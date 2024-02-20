apt-get install python3 gcc libglib2.0-dev libflint-dev

project_dir="$(dirname "$0")"

cp "$project_dir/jina.py" /usr/local/bin/jina
chmod +x /usr/local/bin/jina

mkdir -p /usr/local/lib/jina/
cp -r "$project_dir"/std/* /usr/local/lib/jina/
