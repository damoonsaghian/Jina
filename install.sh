apt-get install vala gcc
project_dir="$(dirname "$0")"
mkdir -p "$project_dir/.cache/vala"
valac -d "$project_dir/.cache/vala" -o jina "$project_dir/src/0.vala"
cp "$project_dir/.cache/vala/jina" /usr/local/bin/
