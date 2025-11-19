#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {

  const char *home = getenv("HOME");

  system("python3 ~/.nullc/nullc.py");

  char path[256];
  char filename[256];
  char command[512];

  snprintf(path, sizeof(path), "%s/.nullc/filenames.txt", home);

  FILE *file = fopen(path, "r");

  fscanf(file, "%s", filename);

  fclose(file);

  snprintf(command, sizeof(command), "gcc program.c -o %s", filename);
  system(command);
  system("rm program.c");

  return 0;
}
