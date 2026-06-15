#ifndef NULL_H
#define NULL_H

#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE 200809L
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <sys/stat.h>
#include <signal.h>
#include <stdbool.h>

#ifndef PATH_MAX
#define PATH_MAX 4096
#endif

// Shared Global Variables
extern volatile sig_atomic_t stop;
extern char global_username[256];
extern char global_cwd[PATH_MAX];
extern char achievements_path[1024];
extern int commands_happened;

// Core Engine Prototypes
void print_ascii_art(void);
void handle_sigint(int sig);
bool check_user(char *user);
void save_command(char *command, char *username);
void execute_command(char *command, const char *home, int *commands_happened);

#endif // NULL_H
