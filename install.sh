ospkg-deb add jina-std lua5.4,lua-penlight,gcc

project_dir="$(dirname "$0")"

cp "$project_dir/jina.lua" "$HOME/.local/bin/jina"
chmod +x "$HOME/.local/bin/jina"

jina "$project_dir"
mkdir -p "$HOME/.local/packages/jina"
cp "$project_dir/.cache/jina/out/*" "$HOME/.local/packages/jina/"

cat <<-'__EOF__' > "$HOME/.local/packages/jina/uninstall.sh"
rm "$HOME/.local/bin/jina"
rm -r "$HOME/.local/packages/jina"
ospkg-deb remove jina-std
__EOF__
