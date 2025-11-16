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

int main() {
	char command[256];
	char cwd[PATH_MAX];

	print_ascci_art();

	while (1) {
		getcwd(cwd, sizeof(cwd));
		out("%s > ", cwd);

	if (in("%255s", command) != 1) {
		continue;
	}
	
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
		out("\n[0] quit     [1] cls\n[2] color    [3] cd\n[4] mkdir    [5] help\n[6] rpg      [7] ls\n[8] touch    [9] explorer\n[10] rm      [11] shutdown\n[12] ./      [13] ssh\n[14] vnc     [15] sl\n[16] apps    [17] apt_update\n[18] cp      [19] apt_install\n[20] port    [21] neofetch\n[22] chmod   [23] dos\n[24] server  [25] dev_mode\n\n");
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
      sys("nano todo.json");
    }
    else if (strcmp(action, "write") == 0) {
      sys("~/.null/nc/todo");
    }
    else {
      out("\n[+] Something has fucked up\n");
    }
  }
  else if (strcmp(command, "dev_mode") == 0) {
    sys("~/.null/nc/dev_mode");
  }





	}
	return 0;
}
