[ -f "$HOME/.local/apps/jina/uninstall.sh" ] && sh "$HOME/.local/apps/jina/uninstall.sh"

if command -v dpkg 1>/dev/null; then
	smp-os add jina lua5.3,lua-penlight,gcc,gnunet,git ||
	echo "these packages must be installed on the system:
	lua5.3 lua-penlight gcc gnunet git"
fi

project_dir="$(dirname "$0")"

mkdir -p "$HOME/.local/apps/jina/"

jina "$project_dir"
ln "$project_dir/.cache/jina/out/std/libstd.jin.so" "$HOME/.local/apps/jina/"

ln "$project_dir/jina/*.lua" "$HOME/.local/apps/jina/"

echo '#!/usr/bin/sh
exec lua jina/jina.lua
' > "$HOME/.local/bin/jina"
chmod +x "$HOME/.local/bin/jina"

project_path_hash="$(echo -n "$project_dir" | md5sum | cut -d ' ' -f1)"

cat <<-__EOF__ > "$HOME/.local/apps/jina/uninstall.sh"
rm ~/.local/bin/jina
rm -r ~/.local/apps/jina
spm-os remove jina 2>/dev/null
spm-os remove jina-$project_path_hash 2>/dev/null
__EOF__
