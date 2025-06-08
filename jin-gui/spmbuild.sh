spm_build jina
spm_import qt
spm_import qt-webkit

"$PKGjina"/exec/jina "$pkg_dir"

ln "$pkg_dir/.cache/jina/std/build/$TARGET/libjina-gui.so" "$build_dir/exp/lib"
