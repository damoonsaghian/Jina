if command -v dpkg 1>/dev/null; then
	spm add jina lua5.3,lua-penlight,gcc,gnunet,git 2>/dev/null ||
	echo "these packages must be installed on the system:
	lua5.3 lua-penlight gcc gnunet git"
fi

project_dir="$(dirname "$0")"

mkdir -p "$project_dir/.cache/spm"

jina "$project_dir"
ln "$project_dir/.cache/jina/out/std/libstd.jin.so" "$project_dir/.cache/spm/"

ln "$project_dir/jina/*.lua" "$project_dir/.cache/spm"

echo '#!/usr/bin/sh
exec lua jina/jina.lua
' > "$project_dir/.cache/spm/bin/jina"
chmod +x "$project_dir/.cache/spm/bin/jina"
