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
	
	-- extract exported identifiers and their types
	local identifiers = {}
	local types = {}
	local mode
	for line in io.lines(jina_file_path) do
		line
	end
	
	-- write it to the .t file
	dir.makepath(path.dirname(t_file_path))
	local t_file = io.open(t_file_path)
	for i = 1, #identifiers, 1 do
		t_file:write(identifiers[i] .. " : " .. types[i] .. "\n")
	end
	t_file:close()
end
