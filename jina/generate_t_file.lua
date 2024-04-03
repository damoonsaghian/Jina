return function (project_path, jin_file_path)
	local relative_extensionless_path = path.splitext(
		path.relpath(jin_file_path, project_path)
	)
	
	local c_file_path = path.join(project_path, ".cache/jina/c", relative_extensionless_path..".c")
	local c_file_mtime = path.getmtime(c_file_path)
	
	local jin_file_mtime = path.getmtime(jin_file_path)
	
	if
		jin_file_mtime and c_file_mtime and	c_file_mtime >= jin_file_mtime and
		os.time() >= c_file_mtime -- make sure that c file is not from future!
	then
		return
	end
	
	local t_file_path = path.join(project_path, ".cache/jina/h", relative_extensionless_path..".t")
	
	--[[
	generate a string containing the exported definitions and their types
	then write the string into the .t file, if:
	, there is no old .t file remained from the last compilation
	, or there is an old .t file, but it's not equal to the generated string (compare their hashes)
	]]
	
	dir.makepath(path.dirname(t_file_path))
	local t_file_handle = io.open(t_file_path)
end
