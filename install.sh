apt-get install rustc git gnunet
cd "$(dirname "$0")"
mkdir -p ".cache/cargo"
rustc --out-dir .cache/cargo -o jina 0.rs
cp "$project_dir/.cache/cargo/release/jina" /usr/local/bin/
