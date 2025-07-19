#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {

	out("\n\n[+] you are chosing with word not a number\n\n");

	char ch[100];
	
	out("[0] quit     [1] chose\n[2] 192.168.x.x\n\n>> ");
	in("%99s", ch);

	if (strcmp(ch, "quit") == 0) {
		out("[+] quiting . . .");
	}
	else if (strcmp(ch, "chose") == 0) {
		char ip[100];
		char command[500];
		out("IP >> ");
		in("%99s", ip);
		string(command, sizeof(command), "vncviewer %s", ip);
		out("[+] starting vncview on %s\n", ip);
		sys(command);
	}
	else if (strcmp(ch, "192.168.x.x") == 0) {
		out("[+] starting vncview on 192.168.x.x\n");
		sys("vncviewer 192.168.x.x");
	}
	else {
		out("[+] wrong input");
	}

	return 0;
}
