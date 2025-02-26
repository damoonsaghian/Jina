spm_import $gnunet_namespace c3c
# if target platform is not ELF freestanding (kernel, embeded)
spm_import $gnunet_namespace flint
spm_import $gnunet_namespace glib
spm_import $gnunet_namespace gstreamer

mkdir -p "$pkg_dir/.cache/spm"

sh "$pkg_dir/jina.sh" "$pkg_dir"
ln "$pkg_dir/.cache/jina/out/$ARCH/std/libstd.jin.so" "$pkg_dir/.cache/spm/$ARCH/"

ln "$pkg_dir"/jina/jina.sh "$pkg_dir/.cache/spm/$ARCH/"

echo '#!/usr/bin/env sh
sh "$(dirname "$(realpath "$0")")/../jina.sh" "$@"
' > "$pkg_dir/.cache/spm/$ARCH/exec/jina"
chmod +x "$pkg_dir/.cache/spm/$ARCH/exec/jina"

spm_xport inst/cmd jina
