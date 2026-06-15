#include "null.h"

void save_command(char *command, char *username) {
    const char *home = getenv("HOME");
    char cache_path[256];
    snprintf(cache_path, sizeof(cache_path), "%s/.null/cache/%s", home, username);
    FILE *file = fopen(cache_path, "a");
    if (file) {
        fprintf(file, "%s\n", command);
        fclose(file);
    }
}

bool check_user(char *user) {
    const char *home = getenv("HOME");
    char path[256];
    char line[256];

    snprintf(path, sizeof(path), "%s/.null/cache/users", home);

    FILE *file = fopen(path, "r");
    if (!file) {
        return false;
    }

    while (fgets(line, sizeof(line), file)) {
        line[strcspn(line, "\n")] = '\0';

        if (strcmp(line, user) == 0) {
            fclose(file);
            return true;
        }
    }

    fclose(file);
    return false;
}
