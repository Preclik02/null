#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <sys/stat.h>

void print_ascci_art() {
    out(
        "  _   _       _ _ \n"
        " | \\ | |     | | |\n"
        " |  \\| |_   _| | |\n"
        " | . ` | | | | | |\n"
        " | |\\  | |_| | | |\n"
        " |_| \\_|\\__,_|_|_|\n\n"
    );
}
void save_command(char *command, char *username) {
  const char *home = getenv("HOME");
  char cache_path[256];
  string(cache_path, sizeof(cache_path), "%s/.null/cache/%s", home, username);
  FILE *file = fopen(cache_path, "a");
  fout(file, "%s\n", command);
  fclose(file);
}
void send_log(char *username) {
  out("[+] Call from func send_log(char *username); it is not done yet dumbass\n");
}

int main() {

  const char *home = getenv("HOME");

  if (!home) return 1;

	char command[256];
	char cwd[PATH_MAX];
  char username[256];
  char path[256];
  char user[256];
  char password[256];
  char password_ch[256];

  int commands_happened = 0;

  sys("clear");

	print_ascci_art();


  out("\n[-] host/user  >> ");
  in("%255s", user);

  if (strcmp(user, "host") == 0) {
    printf("\n[+] You are now a host\n\n");
    string(username, sizeof(username), "host");
  }
  string(path, sizeof(path), "%s/.null/cache/username", home);
  if (strcmp(user, "user") == 0) {
    string(path, sizeof(path), "%s/.null/cache/username", home);
    if (access(path, F_OK) == 0) {
      FILE *user_check = fopen(path, "r");
      fin(user_check, "%s\n%s", username, password);
      fclose(user_check);
      out("\n[-] Password >> ");
      scanf("%255s", password_ch);
      if (strcmp(password_ch, password) != 0) {
        return 1;
      }
      out("\n[+] Welcome, %s\n\n", username);
    }
    else {
      out("\n[-] Username >> ");
      in("%255s", username);
      out("\n[-] Password >> ");
      in("%255s", password);
      char command1[256];
      string(command1, sizeof(command1), "touch %s", path);
      sys(command1);
      FILE *user_check = fopen(path, "w");
      fout(user_check, "%s\n%s", username, password);
      fclose(user_check);
    }
  }

  // --- Replace this by asking of host or username --- //

  




	while (1) {

    if (commands_happened == 10) {
      send_log(username);
      commands_happened = 0;
    }

		getcwd(cwd, sizeof(cwd));
		out("%s > ", cwd);

	if (in("%255s", command) != 1) {
		continue;
	}

  save_command(command, username);
	
	//////////////////
	//// COMMANDS ////
	//////////////////
	if (strcmp(command, "quit") == 0) {
		break;
	}

	else if (strcmp(command, "cls") == 0) {
		sys("clear");
	}

	else if (strcmp(command, "color") == 0) {
		out("\033[1;32m");
	}

	else if (strcmp(command, "cd") == 0) {
		char dirname[256];
		out("dir name >> ");
		in("%255s", dirname);
		if (chdir(dirname) != 0) {
			perror("cd failed");
		}
	}

	else if (strcmp(command, "mkdir") == 0) {
		char dirname[256];
		out("dir name >> ");
		in("%255s", dirname);
		if (mkdir(dirname, 0755) != 0) {
			perror("mkdir failed");
		}
	}

	else if (strcmp(command, "help") == 0) {
		out("\n[0] quit     [1] cls\n[2] color    [3] cd\n[4] mkdir    [5] help\n[6] oom      [7] ls\n[8] touch    [9] explorer\n[10] rm      [11] shutdown\n[12] ./      [13] ssh\n[14] vnc     [15] sl\n[16] apps    [17] pkg_update\n[18] cp      [19] pkg_install\n[20] port    [21] neofetch\n[22] chmod   [23] dos\n[24] server  [25] dev_mode\n[26] nvim    [27] idek\n[28] ascii\n\n");
	}

	else if (strcmp(command, "rpg") == 0) { 
		sys("~/.null/nc/rpg");
	}

	else if (strcmp(command, "ls") == 0) { 
 		out("\n");
		sys("ls");
		out("\n");
	}

	else if (strcmp(command, "touch") == 0) {
		char dirname[256];
		char command1[500];
		out("dir name >> ");
		in("%255s", dirname);
		string(command1, sizeof(command1), "touch %s", dirname);
		sys(command1);
	}

	else if (strcmp(command, "explorer") == 0) {
		sys("xdg-open /");
	}

	else if (strcmp(command, "rm") == 0) {
		char dirname[256];
		char command1[500];
		out("dir name >> ");
		in("%255s", dirname);
		string(command1, sizeof(command1), "rm %s", dirname);
		sys(command1);
	}

	else if (strcmp(command, "shutdown") == 0) {
		sys("shutdown 0");
	}

	else if (strcmp(command, "./") == 0) {
		char filename[256];
		char command1[500];
		out("file name >> ");
		in("%255s", filename);
		string(command1, sizeof(command1), "./%s", filename);
		sys(command1);
	}

	else if (strcmp(command, "ssh") == 0) { 
		sys("~/.null/nc/ssh_connect");
	}

	else if (strcmp(command, "vnc") == 0) { 
		sys("~/.null/nc/vnc_connect");
	}

	else if (strcmp(command, "sl") == 0) {
		sys("sl");
	}

	else if (strcmp(command, "apps") == 0) {
		sys("~/.null/nc/apps");
	}

	else if (strcmp(command, "pkg_update") == 0) {
		sys("sudo pacman -Syu");
	}

	else if (strcmp(command, "pkg_install") == 0) {	
		char pacname[256];
		char command1[500];
		out("package name >> ");
		in("%255s", pacname);
		string(command1, sizeof(command1), "sudo pacman -S %s", pacname);
		sys(command1);
	}

	else if (strcmp(command, "cp") == 0) {
		char path1[2000];
		char path2[2000];
		char command1[5000];
		out("path to file you wanna coppy >> ");
		in("%1999s", path1);
		out("path to where you wanna copy >> ");
		in("%1999s", path2);
		string(command1, sizeof(command1), "cp %s %s", path1, path2);
		sys(command1);
	}

	else if (strcmp(command, "port_scan") == 0) {
		sys("~/.null/nc/port_scan");
	}

	else if (strcmp(command, "neofetch") == 0) {
		sys("neofetch");
	}

	else if (strcmp(command, "chmod") == 0) {
		char filename[256];
		char command1[500];
		out("file you wanna make executable >> ");
		in("%255s", filename);
		string(command1, sizeof(command1), "chmod +x %s", filename);
		sys(command1);
	}

	else if (strcmp(command, "dos") == 0) {	
		sys("~/.null/nc/dos");
	}

	else if (strcmp(command, "server") == 0) {
		sys("~/.null/nc/server");
	}

  else if (strcmp(command, "todo") == 0) {
    char action[256];
    out("\n[-] Do you want to open/write >> ");
    in("%255s", action);
    if(strcmp(action, "open") == 0) {
      sys("idek todo.json");
    }
    else if (strcmp(action, "write") == 0) {
      sys("~/.null/nc/todo");
    }
    else {
      out("\n[+] Something has fucked up\n");
    }
  }
  else if (strcmp(command, "dev_mode") == 0) {
    char cache_path[256];
    char mode_path[256];
    string(cache_path, sizeof(cache_path), "%s/.null/cache/dev_mode.cache", home);
    sys("~/.null/nc/dev_mode");
    FILE *file = fopen(cache_path, "r");
    if (!file) return 1;
    fin(file, "PATH >> %s", mode_path);
    fclose(file);
    if (chdir(mode_path) != 0) {
      perror("chdir");
      return 1;
    }
    sys("idek todo.json");
  }
  else if (strcmp(command, "nvim") == 0) {
    char filename[256];
    char command1[256];
    out("\n[-] File name >> ");
    in("%255s", filename);
    string(command1, sizeof(command1), "nvim %s", filename);
    sys(command1);
  }
  else if (strcmp(command, "idek") == 0) {
    char filename[256];
    char command1[256];
    out("\n[-] Filename >> ");
    in("%255s", filename);
    string(command1, sizeof(command1), "idek %s", filename);
    sys(command1);
  }
  else if (strcmp(command, "ascii") == 0) {
    char text[512];
    char command1[256];
    out("\n[-] Text >> ");
    in("%511s", text);
    string(command1, sizeof(command1), "figlet %s", text);
    sys(command1);
  }

  commands_happened += 1;




	}
	return 0;
}
