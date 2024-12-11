project_dir="$(dirname "$0")"

spm_include $gnunet_namespace python
spm_include $gnunet_namespace clang

mkdir -p "$project_dir/.cache/spm"

python "$project_dir/jina/" "$project_dir"
ln "$project_dir/.cache/jina/out/std/libstd.jin.so" "$project_dir/.cache/spm/"

ln "$project_dir"/jina/*.lua "$project_dir/.cache/spm/"

cat <<-'__EOF__' > "$project_dir/.cache/spm/0"
#!/usr/bin/sh
this_dir = "$(dirname "$(realpath "$0")")"
args="$(printf "'%s', " "$@")"
find "$this_dir" -name '?*.lua' -type f -printf "%P\n" | lua5.3 -e "
	for lua_file_relative_path in io:lines() do
		local dir_part = string.gsub(lua_file_relative_path, '/[^/]+$', '')
		local env = _G
		for subdir in string.gmatch(dir_part, '[^/]+') do
			env[subdir] = {}
			env = env[subdir]
		end
		loadfile('$this_dir'..'/'..lua_file_relative_path, 'bt', env)()
	end
	main($args)
"
__EOF__
chmod +x "$project_dir/.cache/spm/0"
