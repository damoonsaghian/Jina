// output can be null
File File_open(String path, String mode = "") {}

// create a new file for writing (truncating it if it already exists)
File File_create(String path) {}

void File_delete(String path) {}

void File_move(String source_path, String destination_path) {}

void File_copy(String source_path, String destination_path) {}

// max_size in megabytes
Array_Int8 File_read(File self, int max_size) {}

void File_write(File self, Array_Int8 data) {}

void File_close(File self) {}
