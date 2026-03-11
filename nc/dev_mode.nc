#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main() {

  const char *home = getenv("HOME");

  if (!home) return 1;
  char path[256] = {0};
  char cache_path[256];
	int mode_selected;
	char c_mode_path[256];
	char py_mode_path[256];
	char asm_mode_path[256];
	
	string(cache_path, sizeof(cache_path), "%s/.null/cache/dev_mode.cache", home);

	if (access(cache_path, F_OK) == 0) { 
		
		FILE *file = fopen(cache_path, "r");
		if (!file) return 1;
		fin(file, "selected_mode >> %d", &mode_selected);
		fin(file, "\nc_mode_path >> %s", c_mode_path);
		fin(file, "\npy_mode_path >> %s", py_mode_path);
		fin(file, "\nasm_mode_path >> %s", asm_mode_path);
		fclose(file);

		out("\n[+] Chose by number not word\n");
		out("\n[+] [0] C, [1] Python, [2] Assembly"); 
		out("\n[-] What mode do you want to use >> ");
		in("%d", &mode_selected);
		
		if (mode_selected > 2) {
			out("[+] Mods are selected only throught 0-2");
		}
		else {
			FILE *file = fopen(cache_path, "w");
			if (!file) return 1;
			fout(file, "selected_mode >> %d", mode_selected);
			fout(file, "\nc_mode_path >> %s", c_mode_path);
			fout(file, "\npy_mode_path >> %s", py_mode_path);
			fout(file, "\nasm_mode_path >> %s", asm_mode_path);
			fclose(file);
		}
	}


  else {
    out("\n[-] Path to C dev folder (full path from /) >> ");
    in("%255s", c_mode_path);

		out("\n[-] Path to Python dev folder (full path from /) >> ");
		in("%255s", py_mode_path);

		out("\n[-] Path to Assembly dev folder (full path from /) >> ");
		in("%255s", asm_mode_path);

    FILE *file = fopen(cache_path, "w");

    if (!file) return 1;
		
		mode_selected = 0;

		fout(file, "selected_mode >> %d", mode_selected);
    fout(file, "\nc_mode_path >> %s", c_mode_path);
		fout(file, "\npy_mode_path >> %s", py_mode_path);
		fout(file, "\nasm_mode_path >> %s", asm_mode_path);
    fclose(file);
  }

 
  return 0;
}
