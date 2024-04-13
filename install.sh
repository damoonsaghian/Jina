<<'#'
package management in Debian (and in fact, other distros) is a really complex endeavour
but there is a simple and elegant method (as far as i know, not yet implemented anywhere) in which:
, there is no need for a dependency database
. there is no need for a central directory containing all libraries

any directory can be a package just by putting a "install.sh" in it
the script in "install.sh" does these:
, if user id is 0 (root):
	install_dir=/usr
	cache_dir=/var/cache
, otherwise just exit and say "root is needed", or:
	install_dir=~/.local
	cahe_dir=~/.cache
, downloads dependencies (using gnunet or git) into "/var/cache/packages/package-name",
	and runs their "install.sh"
, hard'link all the libs in all "$install_dir/packages/dep_package_name" directories,
	into "$install_dir/packages/package_name"
, hard'link the binary files (executable and libraries) into "$install_dir/packages/package-name/" directories
, an executable shell script will be created in "$install_dir/bin" to run executables of the package,
		with environment variable "LD_LIBRARY_PATH=." set
, puts shared data inside "$install_dir/share"
, puts additional system configs inside "/etc" "/boot"
, puts "uninstall.sh" in package directory, that will clear the package

this way, packages can easily be installed by users (instead of system'wide):
download (using gnunet or git) packages into "~/.cache/packages/url-hash/"
run the "install.sh" script which:
, downloads dependencies, and runs their "install.sh"
, hard'link all the libs in all "~/.local/packages/dep_package_name" directories into "~/.local/packages/package_name"
, hard link binary files into "~/.local/packages/package_name"
, an executable shell script will be created in "~/.local/bin" to run executables of the package,
		with environment variable "LD_LIBRARY_PATH=." set
, puts shared inside "~/.local/share"
, puts "uninstall.sh" in package directory, that will clear the package from user's home
#

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
