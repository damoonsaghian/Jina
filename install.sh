if [ $1 = remove ]; then
	rm "$HOME/.local/bin/jina"
	rm -r "$HOME/.local/packages/jina"
	exit
fi

# lua5.4 lua-penlight gcc
# if these are not installed on system, download and install them

project_dir="$(dirname "$0")"

cp "$project_dir/jina.lua" "$HOME/.local/bin/jina"
chmod +x "$HOME/.local/bin/jina"

jina "$project_dir"
mkdir -p "$HOME/.local/packages/jina"
cp "$project_dir/.cache/jina/out/*" "$HOME/.local/packages/jina/"
