#include "null.h"

void execute_command(char *command, const char *home, int *commands_happened) {
    (void)home; // Explicitly silence the unused parameter warning
    char path[512];

    if (strcmp(command, "quit") == 0) {
        snprintf(path, sizeof(path), "/usr/local/lib/null/cache/achievements");
        FILE *file = fopen(path, "w");
        if (file) {
            fprintf(file, "commands_happened --> %d", *commands_happened);
            fclose(file);
        }
        stop = 1; // Signal the loop in main to stop
    }

    else if (strcmp(command, "cls") == 0) {
        system("clear");
    }

    else if (strcmp(command, "cd") == 0) {
        char dirname[256];
        printf("dir name >> ");
        fflush(stdout);
        if (scanf("%255s", dirname) == 1) {
            if (chdir(dirname) != 0) {
                perror("cd failed");
            }
        } else {
            clearerr(stdin);
        }
    }

    else if (strcmp(command, "mkdir") == 0) {
        char dirname[256];
        printf("dir name >> ");
        fflush(stdout);
        if (scanf("%255s", dirname) == 1) {
            if (mkdir(dirname, 0755) != 0) {
                perror("mkdir failed");
            }
        } else {
            clearerr(stdin);
        }
    }

    else if (strcmp(command, "help") == 0) {
        printf("\n"
            "[0]  quit             [1]  cls\n"
            "[2]  red              [3]  cd\n"
            "[4]  mkdir            [5]  help\n"
            "[6]  ls               [7]  touch\n"
            "[8]  rm               [9]  shutdown\n"
            "[10] ./               [11] ssh\n"
            "[12] pkg_update       [13] cp\n"
            "[14] pkg_install      [15] port\n"
            "[16] jayfetch         [17] chmod\n"
            "[18] purple           [19] white\n"
            "[20] dev_mode         [21] idek\n"
            "[22] ascii            [23] green\n"
            "[24] blue             \n"
            "           \n\n"
        );
    }

    else if (strcmp(command, "ls") == 0) {
        printf("\n");
        system("ls");
        printf("\n");
    }

    else if (strcmp(command, "touch") == 0) {
        char dirname[256];
        char command1[500];
        printf("dir name >> ");
        fflush(stdout);
        if (scanf("%255s", dirname) == 1) {
            snprintf(command1, sizeof(command1), "touch %s", dirname);
            system(command1);
        } else {
            clearerr(stdin);
        }
    }

    else if (strcmp(command, "rm") == 0) {
        char dirname[256];
        char command1[500];
        printf("dir name >> ");
        fflush(stdout);
        if (scanf("%255s", dirname) == 1) {
            snprintf(command1, sizeof(command1), "rm %s", dirname);
            system(command1);
        } else {
            clearerr(stdin);
        }
    }

    else if (strcmp(command, "shutdown") == 0) {
        system("shutdown 0");
    }

    else if (strcmp(command, "./") == 0) {
        char filename[256];
        char command1[500];
        printf("file name >> ");
        fflush(stdout);
        if (scanf("%255s", filename) == 1) {
            snprintf(command1, sizeof(command1), "./%s", filename);
            system(command1);
        } else {
            clearerr(stdin);
        }
    }

    else if (strcmp(command, "ssh") == 0) {
        char command1[1024]; 
        char user[256];
        char ip[256];
        printf("\n[-] User >> ");
        if (scanf("%255s", user) == 1) {
            printf("\n[-] Ip >> ");
            if (scanf("%255s", ip) == 1) {
                snprintf(command1, sizeof(command1), "ssh %s@%s", user, ip);
                system(command1);
            }
        } else {
            clearerr(stdin);
        }
    }

    else if (strcmp(command, "pkg_update") == 0) {
        system("sudo pacman -Syu");
    }

    else if (strcmp(command, "pkg_install") == 0) {
        char pacname[256];
        char command1[500];
        printf("package name >> ");
        fflush(stdout);
        if (scanf("%255s", pacname) == 1) {
            snprintf(command1, sizeof(command1), "sudo pacman -S %s", pacname);
            system(command1);
        } else {
            clearerr(stdin);
        }
    }

    else if (strcmp(command, "cp") == 0) {
        char path1[2000];
        char path2[2000];
        char command1[5000];
        printf("path to file you wanna coppy >> ");
        fflush(stdout);
        if (scanf("%1999s", path1) == 1) {
            printf("path to where you wanna copy >> ");
            fflush(stdout);
            if (scanf("%1999s", path2) == 1) {
                snprintf(command1, sizeof(command1), "cp %s %s", path1, path2);
                system(command1);
            }
        } else {
            clearerr(stdin);
        }
    }

    else if (strcmp(command, "port") == 0) {
        system("/usr/local/lib/null/src/port_scan/port_scan");
    }

    else if (strcmp(command, "jayfetch") == 0) {
        system("/usr/local/lib/null/src/jayfetch/jayfetch");
    }

    else if (strcmp(command, "chmod") == 0) {
        char filename[256];
        char command1[500];
        printf("file you wanna make executable >> ");
        fflush(stdout);
        if (scanf("%255s", filename) == 1) {
            snprintf(command1, sizeof(command1), "chmod +x %s", filename);
            system(command1);
        } else {
            clearerr(stdin);
        }
    }

    else if (strcmp(command, "todo") == 0) {
        char action[256];
        printf("\n[-] Do you want to open/write >> ");
        fflush(stdout);
        if (scanf("%255s", action) == 1) {
            if(strcmp(action, "open") == 0) {
                system("/usr/local/lib/null/src/idek/idek todo.json");
            }
            else if (strcmp(action, "write") == 0) {
                system("/usr/local/lib/null/src/todo/todo");
            }
            else {
                printf("\n[+] Something has fucked up\n");
            }
        } else {
            clearerr(stdin);
        }
    }
    else if (strcmp(command, "dev_mode") == 0) {
        system("/usr/local/lib/null/src/mode/mode");
    }
    else if (strcmp(command, "idek") == 0) {
        char filename[256];
        char command1[512];
        printf("\n[-] Filename >> ");
        fflush(stdout);
        if (scanf("%255s", filename) == 1) {
            snprintf(command1, sizeof(command1), "/usr/local/lib/null/src/idek/idek %s", filename);
            system(command1);
        } else {
            clearerr(stdin);
        }
    }
    else if (strcmp(command, "ascii") == 0) {
        char text[512];
        char command1[1024];
        printf("\n[-] Text >> ");
        fflush(stdout);
        if (scanf("%511s", text) == 1) {
            snprintf(command1, sizeof(command1), "/usr/local/lib/null/src/figlet/figlet %s", text);
            system(command1);
        } else {
            clearerr(stdin);
        }
    }
    else if (strcmp(command, "red") == 0) {
        system("printf \"\\033[0;31m\"");
    }
    else if (strcmp(command, "green") == 0) {
        system("printf \"\\033[0;32m\"");
    }
    else if (strcmp(command, "blue") == 0) {
        system("printf \"\\033[0;34m\"");
    }
    else if (strcmp(command, "white") == 0) {
        system("printf \"\\033[0;37m\"");
    }
    else if (strcmp(command, "purple") == 0) {
        system("printf \"\\033[0;35m\"");
    }
}
