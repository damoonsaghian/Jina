[ -f "$HOME/.local/apps/jina/uninstall.sh" ] && sh "$HOME/.local/apps/jina/uninstall.sh"

upm add jina --deb=lua5.3,lua-penlight,gcc,gnunet,git

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
upm remove jina
upm remove jina-$project_path_hash
__EOF__
