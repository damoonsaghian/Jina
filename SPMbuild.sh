project_dir="$(dirname "$0")"

spm_import $gnunet_namespace python
spm_import $gnunet_namespace clang

mkdir -p "$project_dir/.cache/spm"

python "$project_dir/jina/" "$project_dir" -target "$ARCH"
ln "$project_dir/.cache/jina/out/$ARCH/std/libstd.jin.so" "$project_dir/.cache/spm/$ARCH/"

ln "$project_dir"/jina/* "$project_dir/.cache/spm/$ARCH/"

echo '#!/usr/bin/env sh
python3 "$(dirname "$(realpath "$0")")/../"
' > "$project_dir/.cache/spm/$ARCH/exec/jina"
chmod +x "$project_dir/.cache/spm/$ARCH/exec/jina"

spm_xport inst/cmd jina
