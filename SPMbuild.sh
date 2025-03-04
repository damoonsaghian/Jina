spm_import c3c
# if target platform is not ELF freestanding (kernel or embeded)
spm_import flint
spm_import glib
spm_import gstreamer

mkdir -p "$pkg_dir/.cache/spm"

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
c3c build $TARGET --path "$pkg_dir/.cache/c3c"
spm_xport jina inst/cmd

"$build_dir/exec/jina" "$pkg_dir"
ln "$pkg_dir/.cache/jina/std/build/$TARGET/libstd.jin.so" "$build_dir/"
