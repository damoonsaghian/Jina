spm_import clang

# build jina
spm_xcript jina inst/cmd

spm_import gmp
spm_import mpfr
spm_import arrayfire
spm_import libav
spm_import sdl
spm_import sdl-webkit

"$build_dir/exec/jina" "$pkg_dir"
ln "$pkg_dir/.cache/jina/std/build/$TARGET/libstd.jin.so" "$build_dir/exp/lib"

ln "$pkg_dir/.cache/jina/std/build/$TARGET/libcodec.jin.so" "$build_dir/exp/lib"

ln "$pkg_dir/.cache/jina/std/build/$TARGET/libgui.jin.so" "$build_dir/exp/lib"
