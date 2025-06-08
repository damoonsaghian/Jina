spm_build jina
spm_import gmp
spm_import mpfr
spm_import arrayfire
spm_import qt

"$PKGjina"/exec/jina "$pkg_dir"

ln "$pkg_dir/.cache/jina/std/build/$TARGET/libjina-std.so" "$build_dir/exp/lib"
