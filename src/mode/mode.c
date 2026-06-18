#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <termios.h>

void enableRawMode(struct termios *orig_termios)  {
  struct termios raw = *orig_termios;
  raw.c_lflag &= ~(ECHO | ICANON);
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}
void disableRawMode(struct termios *orig_termios) {
  tcsetattr(STDIN_FILENO , TCSAFLUSH, orig_termios);
}

void print_mode(int x, char *mode_selected) {
  system("clear");
  if (x == 0) {
    printf("[+] Python mode\n");
    strcpy(mode_selected, "/home/preclik02/code/py");
  }
  else if (x == 1) {
    printf("[+] C mode\n");
    strcpy(mode_selected, "/home/preclik02/code/c");
  }
  else if (x == 2) {
    printf("[+] ASM mode\n");
    strcpy(mode_selected, "/home/preclik02/code/asm");
  }
}



int main() {
  struct termios orig_termios;
  tcgetattr(STDIN_FILENO, &orig_termios);
  enableRawMode(&orig_termios);

  const char *home = getenv("HOME");

  char mode_selected[256];
  char path[256];

  int x = 0;
  print_mode(x, mode_selected);

  char ch;
  while (read(STDIN_FILENO, &ch, 1) == 1 && ch != 'q') {
    if (ch == '\033') {
      char seq[2];
      if (read(STDIN_FILENO, &seq[0], 1) == 1 && read(STDIN_FILENO, &seq[1], 1) == 1) {
        if (seq[0] == '[') {
          switch (seq[1]) {
            case 'A':
              x -= 1; 
              if (x < 0) x = 2;
              print_mode(x, mode_selected); 
              break;
            case 'B': 
              x += 1;
              if (x > 2) x = 0;
              print_mode(x, mode_selected);
              break;
          }
        }
      }
    }
    else if (ch == '\n' || ch == '\r') {
      snprintf(path, sizeof(path), "%s/.mode", home);
      FILE *file = fopen(path, "w");
      fprintf(file, "%s", mode_selected);
      fclose(file);
      system("clear");
      break;
    } 
  
  }
  disableRawMode(&orig_termios);


  printf("\n[+] Execute \"ccd\"\n");

  return 0;
}
