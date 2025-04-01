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

"$build_dir/exec/jina" "$pkg_dir"
ln "$pkg_dir/.cache/jina/std/build/$TARGET/libstd.jin.so" "$build_dir/exp/lib"

spm_import flint
# build math.jin

spm_import gstreamer
# build media.jin

spm_import gtk
# build gui.jin
