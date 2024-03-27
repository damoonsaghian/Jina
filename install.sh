# lua5.4 lua-penlight gcc
# if these are not installed on system, download and install them

project_dir="$(dirname "$0")"

cp "$project_dir/jina.lua" "$HOME/.local/bin/jina"
chmod +x "$HOME/.local/bin/jina"

mkdir -p "$HOME/.local/share/jina"
cp -r "$project_dir"/std.jin "$HOME/.local/share/jina/std"
