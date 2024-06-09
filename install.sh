if command -v dpkg 1>/dev/null; then
	spm add "$(dirname "$(realpath $0)")" lua5.3,lua-penlight,gcc,gnunet,git,libglib2.0-0,libflint
	echo "required packages: lua5.3 lua-penlight gcc gnunet git libglib2.0-0 libflint17"
fi

project_dir="$(dirname "$0")"

mkdir -p "$project_dir/.cache/spm"

jina "$project_dir"
ln "$project_dir/.cache/jina/out/std/libstd.jin.so" "$project_dir/.cache/spm/"

ln "$project_dir/jina/*.lua" "$project_dir/.cache/spm/"

echo '#!/usr/bin/sh
this_script_real_path="$(readlink $0)"
exec lua "$(dirname "$this_script_real_path")/jina.lua"
' > "$project_dir/.cache/spm/0"
chmod +x "$project_dir/.cache/spm/0"
