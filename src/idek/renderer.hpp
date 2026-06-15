#include <string>
#include <vector>
#include "editor.hpp"

void drawStatusBar(const std::string& filename, int row, int col, int totalRows, int cols, EditorMode mode);
void render(const std::vector<std::string>& buffer, int cursorRow, int cursorCol, int scrollOffset, int viewportHeight, int viewportWidth, bool blinkOn, EditorMode mode);
