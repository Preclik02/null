#pragma once
#include <termios.h>

void enableRawMode(termios& orig_termios);
void disableRawMode(termios& orig_termios);
char getch();
void clearScreen();
void moveCursor(int row, int col);
