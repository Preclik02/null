#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main() {

  const char *home = getenv("HOME");

  if (!home) return 1;
  char path[256] = {0};
  char cache_path[256];

  snprintf(cache_path, sizeof(cache_path), "%s/.null/cache/dev_mode.cache", home);

  if (access(cache_path, F_OK) == 0) { }

  else {
    out("\n[-] Path to dev folder (full path from /) >> ");
    in("%255s", path);

    FILE *file = fopen(cache_path, "w");

    if (!file) return 1;

    fout(file, "PATH >> %s", path);
    fclose(file);
  }

  // ADD ASKING FOR MODE AND ADD ACTUAL MODES IN FUTURE //
 
  return 0;
}
