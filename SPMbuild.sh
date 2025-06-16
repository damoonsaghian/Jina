spm_import clang
# build jina
spm_xcript jina inst/cmd

pkg=jin-std
	spm_build jina
	spm_import gmp
	spm_import mpfr
	spm_import arrayfire
	spm_import qt
	
	"$PKGjina"/exec/jina "$pkg_dir"
	
	ln "$pkg_dir/.cache/jina/std/build/$TARGET/libjina-std.so" "$build_dir/exp/lib"

pkg=jin-gui
	spm_build jina
	spm_import qt
	spm_import qt-webkit
	
	"$PKGjina"/exec/jina "$pkg_dir"
	
	ln "$pkg_dir/.cache/jina/std/build/$TARGET/libjina-gui.so" "$build_dir/exp/lib"

pkg=jin-media
	spm_build jina
	spm_import qt-multimedia
	
	"$PKGjina"/exec/jina "$pkg_dir"
	
	ln "$pkg_dir/.cache/jina/std/build/$TARGET/libjina-codec.so" "$build_dir/exp/lib"
