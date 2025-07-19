#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
	
	out("\n\n[+] you are chosing by word not number\n\n");
	
	char ch[100];

	out("[0] quit     [1] chose\n[2] 192.168.x.x\n\n>> ");
	in("%99s", ch);

	if (strcmp(ch, "quit") == 0) {
		out("[+] quiting . . .");
	}
	else if (strcmp(ch, "chose") == 0) {
		char ip[100];
		char command[500];
		char username[100];
		out("IP >> ");
		in("%99s", ip);
		out("username >> ");
		in("%99s", username);
		string(command, sizeof(command), "ssh %s@%s", username, ip); 
		out("[+] connecting to %s@%s with ssh\n", username, ip);
		sys(command);
	}
	else if (strcmp(ch, "192.168.x.x") == 0) {
		out("[+] connecting to 192.168.x.x with ssh\n");
		sys("ssh 192.168.x.x");
	}
	else {
		out("[+] wrong input");
	}
	
	return 0;
}
