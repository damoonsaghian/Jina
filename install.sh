echo 'Jina needs "lua lua-penlight gcc" packages'
printf "are these installed on system? (Y/n) "
read -r ans
if [ "$ans" = "n" ] || [ "$ans" = "no" ]; then
	echo "so go install them first"
	echo "to install them on Debian based systems:"
	printf "\tsudo apt install lua5.4 lua-penlight gcc\n"
fi

project_dir="$(dirname "$0")"

cp "$project_dir/jina.lua" "$HOME/.local/bin/jina"
chmod +x "$HOME/.local/bin/jina"

jina "$project_dir"
mkdir -p "$HOME/.local/packages/jina"
cp "$project_dir/.cache/jina/out/*" "$HOME/.local/packages/jina/"

cat <<-'__EOF__' > "$HOME/.local/packages/jina/uninstall.sh"
rm "$HOME/.local/bin/jina"
rm -r "$HOME/.local/packages/jina"
exit
__EOF__
