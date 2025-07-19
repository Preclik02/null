#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {

	out("\n\n[+] make sure you have the app you want to open installed\n");
	out("[+] you are chosing by the name not the number\n\n");
	
	char x[50];
	char command[200];

	out("[1] quit     [2] explorer\n[3] spotify  [4] google-chorme\n\n>> ");
	in("%49s", x);

	if (strcmp(x, "quit") == 0) {
		out("[+] quiting . . .");
	}
	else if (strcmp(x, "explorer") == 0) {	
		sys("xdg-open .");
	}
	else if (strcmp(x, "spotify") == 0) {
		sys("spotify");
	}
	else if (strcmp(x, "google-chrome") == 0) {
		sys("google-chrome");
	}
	else {
		out("[+] wrong input\n\n");
	}
	return 0;
}
