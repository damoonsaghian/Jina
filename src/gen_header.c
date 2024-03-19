void generate_header_file(GFile* jina_file, GFile* h_file) {
	/*
	generate a string containing the type signature of all exported definitions
	 if:
	, there is no old one remained from the last compilation
	, if there is an old .t file, but it's not equal to the generated string (compare their hashes)
	write the string into a .t file, and then from it, generate a .h file
	*/
	
	GFileOutputStream* jina_file_stream = g_file_read(jina_file, NULL, NULL);
	GFileInputStream* h_file_stream = g_file_create(h_file, 0, NULL, NULL);
	
	g_object_unref(jina_file_stream);
	g_object_unref(h_file_stream);
}
