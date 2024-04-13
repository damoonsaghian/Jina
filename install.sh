ospkg-deb add jina lua5.4,lua-penlight,gcc

project_dir="$(dirname "$0")"

mkdir -p "$HOME/.local/apps/jina/"

jina "$project_dir"
cp "$project_dir/.cache/jina/out/std/libstd.jin.so" "$HOME/.local/apps/jina/"

cp "$project_dir/jina/*.lua" "$HOME/.local/apps/jina/"

echo '#!/usr/bin/sh
cd "$HOME/.local/apps"
exec lua jina/jina.lua
' > "$HOME/.local/bin/jina"
chmod +x "$HOME/.local/bin/jina"

cat <<-'__EOF__' > "$HOME/.local/apps/jina/uninstall.sh"
rm "$HOME/.local/bin/jina"
rm -r "$HOME/.local/apps/jina"
ospkg-deb remove jina
ospkg-deb remove jina-std
__EOF__
