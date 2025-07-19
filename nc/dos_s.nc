#include <stdio.h>
#include <stdlib.h>

int main() {
	out("[+] stoping hping3 comunication\n");
	sys("sudo pkill -9 hping3");
	return 0;
}
