upm_import clang
# build jina
upm_xcript jina inst/cmd

pkg=jin-std

upm_build jina
upm_import gmp
upm_import mpfr
upm_import arrayfire
upm_import qt

"$PKGjina"/exec/jina "$pkg_dir"

ln "$pkg_dir/.cache/jina/std/build/$TARGET/libjina-std.so" "$build_dir/exp/lib"

pkg=jin-gui

upm_build jina
upm_import qt
upm_import qt-webkit

"$PKGjina"/exec/jina "$pkg_dir"

ln "$pkg_dir/.cache/jina/std/build/$TARGET/libjina-gui.so" "$build_dir/exp/lib"

pkg=jin-media

upm_build jina
upm_import qt-multimedia

"$PKGjina"/exec/jina "$pkg_dir"

ln "$pkg_dir/.cache/jina/std/build/$TARGET/libjina-codec.so" "$build_dir/exp/lib"
