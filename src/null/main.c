#include "null.h"

// Instantiate global variables
volatile sig_atomic_t stop = 0;
char global_username[256] = "host";
char global_cwd[PATH_MAX] = "";
char achievements_path[1024] = "/usr/local/lib/null/cache/achievements";
int commands_happened = 0;

void print_ascii_art(void) {
    printf(
        "  _   _       _ _ \n"
        " | \\ | |     | | |\n"
        " |  \\| |_   _| | |\n"
        " | . ` | | | | | |\n"
        " | |\\  | |_| | | |\n"
        " |_| \\_|\\__,_|_|_|\n\n"
    );
}

void handle_sigint(int sig) {
    (void)sig; // Silence unused warning
    printf("\n\n[!] Ctrl+C pressed. Saving history and exiting null shell safely...\n");
    
    // Auto-save history right before immediate exit
    if (achievements_path[0] != '\0') {
        FILE *file = fopen(achievements_path, "w");
        if (file) {
            fprintf(file, "commands_happened --> %d", commands_happened);
            fclose(file);
        }
    }
    exit(0);
}

int main(void) {
    // Initial handler configuration
    signal(SIGINT, handle_sigint);

    char command[256];
    char path[1024]; 
    char user[256];
    char password[256];
    char password_ch[256];

    system("clear");
    print_ascii_art();

    if (access(achievements_path, F_OK) == 0) {
        FILE *file = fopen(achievements_path, "r");
        if (file) {
            if (fscanf(file, "commands_happened --> %d", &commands_happened) != 1) {
                commands_happened = 0;
            }
            fclose(file);
        }
    } else {
        FILE *file = fopen(achievements_path, "w");
        if (file) {
            fprintf(file, "commands_happened --> %d", commands_happened);
            fclose(file);
        }
    }

    printf("\n[-] username   >> ");
    if (scanf("%255s", user) != 1) return 1;

    if (check_user(user)) {
        printf("\n[-] Password >> ");
        if (scanf("%255s", password) != 1) return 1;
        snprintf(path, sizeof(path), "/usr/local/lib/null/cache/%s_cred", user);
        FILE *file = fopen(path, "r");
        if (file) {
            if (fscanf(file, "%*s\n%255s", password_ch) != 1) {
                password_ch[0] = '\0';
            }
            fclose(file);
        }
        if (strcmp(password_ch, password) != 0) {
            return 1;
        }
        snprintf(global_username, sizeof(global_username), "%s", user);
        printf("\n[+] Welcome, %s\n\n", global_username);
    } else {
        char check[256];
        printf("\n[-] create (new user)/host >> ");
        if (scanf("%255s", check) != 1) return 1;
        if (strcmp(check, "create") == 0) {
            printf("\n[-] Password >> ");
            if (scanf("%255s", password) != 1) return 1;
            snprintf(path, sizeof(path), "/usr/local/lib/null/cache/%s_cred", user);
            FILE *file = fopen(path, "w");
            if (file) {
                fprintf(file, "%s\n%s", user, password);
                fclose(file);
            }
            snprintf(path, sizeof(path), "/usr/local/lib/null/cache/users");
            file = fopen(path, "a");
            if (file) {
                fprintf(file, "%s\n", user);
                fclose(file);
            }
            snprintf(global_username, sizeof(global_username), "%s", user);
        } else if (strcmp(check, "host") == 0) {
            printf("\n[+] You are host\n");
            snprintf(global_username, sizeof(global_username), "host");
        }
    }

    // --- MAIN SHELL LOOP ---
    while (!stop) {
        if (commands_happened == 1000) {
            printf("\n[+] You reached 1k commands used... Thanks for using null\n");
        }

        if (!getcwd(global_cwd, sizeof(global_cwd))) {
            perror("getcwd failed");
        }
        printf("[%s] %s > ", global_username, global_cwd);
        fflush(stdout);

        if (scanf("%255s", command) != 1) {
            clearerr(stdin);
            continue;
        }

        save_command(command, global_username);

        // NULL_H blueprint passes NULL since commands.c ignores it now anyway
        execute_command(command, NULL, &commands_happened);

        commands_happened += 1;
    }

    // Standard loop termination save
    FILE *file = fopen(achievements_path, "w");
    if (file) {
        fprintf(file, "commands_happened --> %d", commands_happened);
        fclose(file);
    }

    return 0;
}
