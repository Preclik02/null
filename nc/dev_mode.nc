#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main() {

  const char *home = getenv("HOME");

  if (!home) {
    return 1;
  }

  char path[256];
  char cache_path[256];
  char command[512];

  snprintf(cache_path, sizeof(cache_path), "%s/.null/cache/dev_mode.cache", home);

  if (access(cache_path, F_OK) == 0) {
    FILE *file = fopen(cache_path, "r");

    if (!file) return 1;

    fin(file, "PATH >> %s", path);
    fclose(file);
  }

  else {
    out("\n[-] Path to dev folder (full path from /) >> ");
    in("%255s", path);

    FILE *file = fopen(cache_path, "w");

    if (!file) return 1;

    fout(file, "PATH >> %s", path);
    fclose(file);
  }

  // ADD ASKING FOR MODE AND ADD ACTUAL MODES IN FUTURE //
 
  if (chdir(path) != 0) {
    perror("chdir");
    return 1;
  }

  sys("nano todo.json");

  return 0;
}
