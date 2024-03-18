char generate_header_file(GFile* jina_file, GFile* h_file) {
	/*
	generate header and store it in a String var
	generate its hash
	if there is an old header file (remained from the last compilation),
	and it's not equal to the new one (compare their hashes), overwrite the old one
	otherwise just keep the old one, and return(0)
	
	also a .t file is generated which contains the type signature of all exported definitions
	*/
	
	GFileOutputStream* jina_file_stream = g_file_read(jina_file, NULL, NULL);
	GFileInputStream* h_file_stream = g_file_create(h_file, 0, NULL, NULL);
	
	g_object_unref(jina_file_stream);
	g_object_unref(h_file_stream);
	
	return(1);
}
