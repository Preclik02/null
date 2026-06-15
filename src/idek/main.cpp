#include <iostream>
#include <vector>
#include <string>
#include <chrono>
#include <algorithm>
#include <unistd.h>
#include <sys/select.h>

#include "editor.hpp"
#include "terminal.hpp"
#include "file_io.hpp"
#include "renderer.hpp"

int main(int argc, char* argv[]) {
    std::string filename;

    // Mode 1: If an argument is given, use it directly
    if (argc >= 2) {
        filename = argv[1];
    } 
    // Mode 2: If no argument is given, ask the user interactively
    else {
        std::cout << R"(
 _      _      _
(_)    | |    | |
 _  __| | ___| | __
| |/ _` |/ _ \ |/ /
| | (_| |  __/   <
|_|\__,_|\___|_|\_\
)" << std::endl << std::endl;

        std::cout << "Filename: ";
        std::getline(std::cin, filename);

        // If the user just hits Enter without typing anything, exit gracefully
        if (filename.empty()) {
            std::cout << "No filename provided. Exiting.\n";
            return 1;
        }
    }

    // Now that we definitely have a filename, kick off raw mode and load the file
    termios orig_termios;
    enableRawMode(orig_termios);

    std::vector<std::string> buffer;
    loadFile(filename, buffer);

    int row = 0;
    int col = 0;
    const int viewportHeight = 25;
    const int viewportWidth = 80; 
    int scrollOffset = 0;

    EditorMode mode = NORMAL; 
    char lastChar = '\0';     

    bool blinkOn = true;
    auto lastBlink = std::chrono::steady_clock::now();

    render(buffer, row, col, scrollOffset, viewportHeight, viewportWidth, blinkOn, mode);

    while (true) {
        auto now = std::chrono::steady_clock::now();
        std::chrono::duration<double, std::milli> diff = now - lastBlink;
        if (diff.count() >= 500) {
            blinkOn = !blinkOn;
            lastBlink = now;
            render(buffer, row, col, scrollOffset, viewportHeight, viewportWidth, blinkOn, mode);
        }

        fd_set set;
        struct timeval timeout;
        FD_ZERO(&set);
        FD_SET(STDIN_FILENO, &set);
        timeout.tv_sec = 0;
        timeout.tv_usec = 100000; 

        int rv = select(STDIN_FILENO + 1, &set, nullptr, nullptr, &timeout);
        if (rv == -1) {
            disableRawMode(orig_termios);
            std::cerr << "Error reading input" << std::endl;
            break;
        } else if (rv == 0) {
            continue;
        }

        char ch = getch();

        if (ch == 3) { 
            clearScreen();
            disableRawMode(orig_termios);
            std::cout << "Editor exited without saving." << std::endl;
            break;
        }

        if (mode == NORMAL) {
            if (ch == 'a') {
                mode = INSERT;
                if (col < (int)buffer[row].size()) col++;
            } 
            else if (ch == 'h') { if (col > 0) col--; } 
            else if (ch == 'l') { if (col < (int)buffer[row].size()) col++; } 
            else if (ch == 'k') { if (row > 0) row--; } 
            else if (ch == 'j') { if (row < (int)buffer.size() - 1) row++; } 
            else if (ch == 'g') {
                if (lastChar == 'g') { 
                    row = 0; col = 0; lastChar = '\0';
                } else {
                    lastChar = 'g'; continue; 
                }
            } 
            else if (ch == 'G') { 
                row = (int)buffer.size() - 1; col = 0;
            } 
            else if (ch == ':') { 
                saveFile(filename, buffer);
                clearScreen();
                disableRawMode(orig_termios);
                std::cout << "File saved successfully. Goodbye!" << std::endl;
                break;
            }
            if (ch != 'g') lastChar = '\0';
        } 
        else {
            if (ch == '\033') { 
                mode = NORMAL;
                if (col > 0) col--; 
            } 
            else if (ch == 127 || ch == 8) { 
                if (col > 0) {
                    buffer[row].erase(col - 1, 1); col--;
                } else if (row > 0) {
                    col = (int)buffer[row - 1].size();
                    buffer[row - 1] += buffer[row];
                    buffer.erase(buffer.begin() + row);
                    row--;
                }
            } 
            else if (ch == '\n' || ch == '\r') { 
                std::string newLine = buffer[row].substr(col);
                buffer[row] = buffer[row].substr(0, col);
                buffer.insert(buffer.begin() + row + 1, newLine);
                row++; col = 0;
            } 
            else if (ch == '\t') { 
                buffer[row].insert(col, "  "); col += 2;
            } 
            else if (isprint(ch)) {
                buffer[row].insert(buffer[row].begin() + col, ch);
                col++;
            }
        }

        if (row < 0) row = 0;
        if (row >= (int)buffer.size()) row = (int)buffer.size() - 1;
        if (col < 0) col = 0;
        if (col > (int)buffer[row].size()) col = (int)buffer[row].size();

        int halfView = viewportHeight / 2;
        if (row < halfView) {
            scrollOffset = 0;
        } else if (row > (int)buffer.size() - halfView) {
            scrollOffset = std::max(0, (int)buffer.size() - viewportHeight);
        } else {
            scrollOffset = row - halfView;
        }

        render(buffer, row, col, scrollOffset, viewportHeight, viewportWidth, blinkOn, mode);
    }

    return 0;
}
