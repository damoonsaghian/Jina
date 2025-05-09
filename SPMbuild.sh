spm_import c3c

mkdir -p "$pkg_dir/.cache/c3c"
cat <<-EOF > "$pkg_dir/.cache/c3c/project.json"
{
	"sources": [ "../../jina.c3" ],
	"output": "$build_dir/exec/jina",
	"targets": {
		"$TARGET": {
			"type": "executable",
		},
	},
}
EOF
c3c build release --path "$pkg_dir/.cache/c3c"
spm_xcript jina inst/cmd

spm_import gmp
spm_import mpfr
spm_import lapacke
spm_import glib

"$build_dir/exec/jina" "$pkg_dir"
ln "$pkg_dir/.cache/jina/std/build/$TARGET/libstd.jin.so" "$build_dir/exp/lib"
