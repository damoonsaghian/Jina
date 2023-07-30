apt-get install cargo gnunet

project_dir="$(dirname "$0")"
mkdir -p "$project_dir/.cache/cargo"
cd "$project_dir/.cache/cargo"

[ -L Cargo.toml ] || {
	rm -f Cargo.toml
	ln -s ../../cargo.toml Cargo.toml
}

cargo build --release
cp release/jina /usr/local/bin/
