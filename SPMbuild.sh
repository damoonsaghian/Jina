project_dir="$(dirname "$0")"

spm_import $gnunet_namespace c3c

# a vapi file for flint

mkdir -p "$project_dir/.cache/spm"

sh "$project_dir/jina.sh" "$project_dir"
ln "$project_dir/.cache/jina/out/$ARCH/std/libstd.jin.so" "$project_dir/.cache/spm/$ARCH/"

ln "$project_dir"/jina/jina.sh "$project_dir/.cache/spm/$ARCH/"

echo '#!/usr/bin/env sh
sh "$(dirname "$(realpath "$0")")/../jina.sh" "$@"
' > "$project_dir/.cache/spm/$ARCH/exec/jina"
chmod +x "$project_dir/.cache/spm/$ARCH/exec/jina"

spm_xport inst/cmd jina
