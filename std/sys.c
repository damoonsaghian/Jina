void Sys_print(String message) {}

void Sys_print_err(String message) {}

String Sys_read() {}

struct {File stdin; File stdout} Sys_exec(String program_name, String arguments) {}

String Sys_get_env() {}

String Sys_get_args() {}

String Sys_get_time(String format = "") {}
