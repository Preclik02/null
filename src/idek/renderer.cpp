#include "renderer.hpp"
#include "terminal.hpp"
#include <iostream>
#include <algorithm>

void drawStatusBar(const std::string& filename, int row, int col, int totalRows, int cols, EditorMode mode) {
    std::cout << "\033[7m"; 
    
    std::string modeStr = (mode == NORMAL) ? " -- NORMAL -- " : " -- INSERT -- ";
    std::string status = modeStr + "File: " + filename + " | Ln " + std::to_string(row + 1) + ", Col " + std::to_string(col + 1);
    std::string instructions = " [hjkl][gg][G] | a:Insert | ESC:Normal | ::Save & Exit | Ctrl+C:Abort ";
    std::string fullStatus = status + instructions;

    if ((int)fullStatus.size() < cols) {
        fullStatus += std::string(cols - fullStatus.size(), ' ');
    } else {
        fullStatus = fullStatus.substr(0, cols);
    }

    std::cout << fullStatus;
    std::cout << "\033[0m"; 
}

void render(const std::vector<std::string>& buffer, int cursorRow, int cursorCol, int scrollOffset, int viewportHeight, int viewportWidth, bool blinkOn, EditorMode mode) {
    clearScreen();
    int endLine = std::min(scrollOffset + viewportHeight, static_cast<int>(buffer.size()));

    for (int i = scrollOffset; i < endLine; ++i) {
        std::string lineNum = std::to_string(i + 1);
        const int lineNumWidth = 5;
        if ((int)lineNum.size() < lineNumWidth)
            lineNum = std::string(lineNumWidth - lineNum.size(), ' ') + lineNum;

        if (i == cursorRow) {
            std::cout << "\033[48;5;250m"; 
        }

        std::cout << "\033[90m" << lineNum << " \033[0m";  

        const std::string& line = buffer[i];
        if (i == cursorRow) {
            int len = (int)line.size();
            if (cursorCol > len) cursorCol = len;
            std::cout << "\033[48;5;250m\033[37m"; 

            if (cursorCol > 0)
                std::cout << line.substr(0, cursorCol);

            if (cursorCol < len) {
                if (blinkOn) {
                    std::cout << "\033[1m\033[44m" << line[cursorCol] << "\033[0m\033[48;5;250m\033[37m";
                } else {
                    std::cout << line[cursorCol];
                }
                std::cout << line.substr(cursorCol + 1);
            } else {
                if (blinkOn) {
                    std::cout << "\033[1m\033[44m_\033[0m\033[48;5;250m\033[37m";
                } else {
                    std::cout << " ";
                }
            }
            std::cout << "\033[0m\n";
        } else {
            std::cout << "\033[0m" << line << "\n";
        }
    }

    for (int i = endLine; i < scrollOffset + viewportHeight; ++i) {
        std::string lineNum = std::to_string(i + 1);
        const int lineNumWidth = 5;
        if ((int)lineNum.size() < lineNumWidth)
            lineNum = std::string(lineNumWidth - lineNum.size(), ' ') + lineNum;
        std::cout << "\033[90m" << lineNum << " \033[0m";
        std::cout << "\033[90m~\033[0m\n";
    }

    moveCursor(cursorRow - scrollOffset, cursorCol + 6);
    drawStatusBar("YourFile", cursorRow, cursorCol, (int)buffer.size(), viewportWidth, mode);
}
