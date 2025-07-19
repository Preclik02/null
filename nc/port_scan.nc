#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {

	out("\n[+] trigering sudo\n");
	sys("sudo -v");

	out("\n\n[+] you are chosing by word not number\n\n");
	
	char ch[100];

	out("[0] quit     [1] chose\n[2] p80      [3] p22\n[4] p443     [5] p8080\n[6] p3306    [7] p5900\n\n>> ");
	in("%99s", ch);

	if (strcmp(ch, "quit") == 0) {
		out("[+] quiting . . .");
	}
	else if (strcmp(ch, "chose") == 0) {
		char port[100];
		char command[500];
		out("chose a port >> ");
		in("%99s", port);
		string(command, sizeof(command), "sudo masscan -p%s --range 192.168.0.1-192.168.0.255", port);
		out("[+] starting scan on port %s\n", port);
		sys(command);
	}
	else if (strcmp(ch, "p80") == 0) {
		out("[+] starting scan on port 80\n");
		sys("sudo masscan -p80 --range 192.168.0.1-192.168.0.255");
	}
	else if (strcmp(ch, "p22") == 0) {
		out("[+] starting scan on port 22\n");
		sys("sudo masscan -p22 --range 192.168.0.1-192.168.0.255");
	}
	else if (strcmp(ch, "p443") == 0) {
		out("[+] starting scan on port 443\n");
		sys("sudo masscan -p443 --range 192.168.0.1-192.168.0.255");
	}
	else if (strcmp(ch, "p8080") == 0) {
		out("[+] starting scan on port 8080\n");
		sys("sudo masscan -p8080 --range 192.168.0.1-192.168.0.255");
	}
	else if (strcmp(ch, "p3306") == 0) {
		out("[+] starting scan on port 3306\n");
		sys("sudo masscan -p3306 --range 192.168.0.1-192.168.0.255");
	}
	else if (strcmp(ch, "p5900") == 0) {
		out("[+] starting scan on port 5900\n");
		sys("sudo masscan -p5900 --range 192.168.0.1-192.168.0.255");
	}
	else {
		out("[+] wrong input quiting . . .\n");
	}

	return 0;
}
