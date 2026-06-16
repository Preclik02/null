#include "null.h"

void save_command(char *command, char *username) {
    char cache_path[512];
    // Appends command history directly into the root system asset directory
    snprintf(cache_path, sizeof(cache_path), "/usr/local/lib/null/cache/%s", username);
    FILE *file = fopen(cache_path, "a");
    if (file) {
        fprintf(file, "%s\n", command);
        fclose(file);
    }
}

bool check_user(char *user) {
    char path[512];
    char line[256];

    snprintf(path, sizeof(path), "/usr/local/lib/null/cache/users");

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
