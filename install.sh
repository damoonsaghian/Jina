[ -f "$HOME/.local/apps/jina/uninstall.sh" ] && sh "$HOME/.local/apps/jina/uninstall.sh"

ospkg-deb add jina lua5.4,lua-penlight,gcc

project_dir="$(dirname "$0")"

mkdir -p "$HOME/.local/apps/jina/"

jina "$project_dir"
ln "$project_dir/.cache/jina/out/lib/lib.so" "$HOME/.local/apps/jina/libjina.so"

ln "$project_dir/jina/*.lua" "$HOME/.local/apps/jina/"

echo '#!/usr/bin/sh
cd "$HOME/.local/apps"
exec lua jina/jina.lua
' > "$HOME/.local/bin/jina"
chmod +x "$HOME/.local/bin/jina"

project_path_hash="$(echo -n "$project_dir" | md5sum | cut -d ' ' -f1)"

cat <<-__EOF__ > "$HOME/.local/apps/jina/uninstall.sh"
rm ~/.local/bin/jina
rm -r ~/.local/apps/jina
ospkg-deb remove jina
ospkg-deb remove jina-$project_path_hash
__EOF__
