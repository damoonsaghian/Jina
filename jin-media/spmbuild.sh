spm_build jina
spm_import qt-multimedia

"$PKGjina"/exec/jina "$pkg_dir"

ln "$pkg_dir/.cache/jina/std/build/$TARGET/libjina-codec.so" "$build_dir/exp/lib"
