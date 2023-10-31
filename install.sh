apt-get install nim

cd "$(dirname "$0")"
nimble build
mv jina /usr/local/bin/
