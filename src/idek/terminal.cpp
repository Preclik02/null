#include "terminal.hpp"
#include <unistd.h>
#include <iostream>

void enableRawMode(termios& orig_termios) {
    tcgetattr(STDIN_FILENO, &orig_termios);
    termios raw = orig_termios;
    raw.c_lflag &= ~(ICANON | ECHO);     
    raw.c_cc[VMIN] = 1;                  
    raw.c_cc[VTIME] = 0;                 
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

void disableRawMode(termios& orig_termios) {
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);
}

char getch() {
    char c;
    read(STDIN_FILENO, &c, 1);
    return c;
}

void clearScreen() {
    std::cout << "\033[2J\033[H";
}

void moveCursor(int row, int col) {
    std::cout << "\033[" << (row + 1) << ";" << (col + 1) << "H";
}
