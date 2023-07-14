apt-get install rustc cargo
cd "$(dirname "$0")"
mkdir -p ".cache/cargo"
cargo build --release --target-dir ".cache/cargo"
cp "$project_dir/.cache/cargo/release/jina" /usr/local/bin/
