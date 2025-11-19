#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <ctype.h>
#include <sys/select.h>
#include <sys/ioctl.h>

#def MAX_LENGTH 1024
#def INITIAL_LINES 128

struct termios orig_termios;

void enableRawMode() {
    tcgetattr(STDIN_FILENO, &orig_termios);
    struct termios raw = orig_termios;
    raw.c_lflag &= ~(ICANON | ECHO);
    raw.c_cc[VMIN] = 0; 
    raw.c_cc[VTIME] = 1;
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

void disableRawMode() {
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);
}

char getch() {
    char c;
    if (read(STDIN_FILENO, &c, 1) == 1)
        return c;
    return 0;
}

void clearScreen() { out("\033[2J\033[H"); }
void moveCursor(int row, int col) { out("\033[%d;%dH", row + 1, col + 1); }

void drawStatusBar(const char* filename, int row, int col, int totalRows, int cols) {
    out("\033[7m");
    char status[512];
    string(status, sizeof(status), " File: %s | Ln %d, Col %d ESC:Save & Run Ctrl+C:Exit ", filename, row + 1, col + 1);
    int len = strlen(status);
    if (len < cols) strcat(status, (char*)calloc(cols - len + 1, ' '));
    status[cols] = '\0';
    out("%s", status);
    out("\033[0m");
}

typedef struct {
    char** lines;
    int size;
    int capacity;
} Buffer;

Buffer* createBuffer() {
    Buffer* buf = malloc(sizeof(Buffer));
    buf->capacity = INITIAL_LINES;
    buf->size = 0;
    buf->lines = malloc(sizeof(char*) * buf->capacity);
    return buf;
}

void addLine(Buffer* buf, const char* line) {
    if (buf->size >= buf->capacity) {
        buf->capacity *= 2;
        buf->lines = realloc(buf->lines, sizeof(char*) * buf->capacity);
    }
    buf->lines[buf->size] = strdup(line);
    buf->size++;
}

void freeBuffer(Buffer* buf) {
    for (int i = 0; i < buf->size; i++) free(buf->lines[i]);
    free(buf->lines);
    free(buf);
}

void loadFile(const char* filename, Buffer* buf) {
    FILE* fp = fopen(filename, "r");
    if (!fp) {
        addLine(buf, "");
        return;
    }
    char line[MAX_LENGTH];
    while (fgets(line, sizeof(line), fp)) {
        line[strcspn(line, "\n")] = 0;
        addLine(buf, line);
    }
    fclose(fp);
    if (buf->size == 0) addLine(buf, "");
}

void saveFile(const char* filename, Buffer* buf) {
    FILE* fp = fopen(filename, "w");
    if (!fp) return;
    for (int i = 0; i < buf->size; i++) {
        fout(fp, "%s\n", buf->lines[i]);
    }
    fclose(fp);
}

void compileAndRun(const char* filename) {
    char cmd[512];
    string(cmd, sizeof(cmd), "~/.nullc/nullc_idek %s", filename);
    sys(cmd);
}

void render(Buffer* buf, int row, int col, int scrollOffset, int viewportHeight, int viewportWidth, const char* filename) {
    clearScreen();

    int endLine = scrollOffset + viewportHeight;
    if (endLine > buf->size) endLine = buf->size;

    for (int i = scrollOffset; i < endLine; i++) {
        char lineNum[8];
        string(lineNum, sizeof(lineNum), "%4d ", i + 1);

        out("\033[90m%s\033[0m", lineNum);

        if (i == row) {
            out("\033[47;30m");
            out("%s", buf->lines[i]);
            out("\033[0m");
        } else {
            out("%s", buf->lines[i]);
        }

        out("\n");
    }

    for (int i = endLine; i < scrollOffset + viewportHeight; i++) {
        out("\033[90m%4d ~\033[0m\n", i + 1);
    }

    out("\033[%d;%dH", (row - scrollOffset) + 1, col + 6);

    moveCursor(viewportHeight + 1, 0);
    out("\033[7m File: %s | Ln %d, Col %d ESC:Save & Run Ctrl+C:Exit \033[0m\n",
           filename, row + 1, col + 1);

    fflush(stdout);
}

int main(int argc, char* argv[]) {
    out(" _     _      _     \n");
    out("(_)   | |    | |    \n");
    out(" _  __| | ___| | __ \n");
    out("| |/ _` |/ _ \\ |/ / \n");
    out("| | (_| |  __/   <  \n");
    out("|_|\\__,_|\\___|_|\\_\\\n\n");
    out("\n[+] \"idek\" was made specifically for nullc files but you can write & edit all file types just say \"n\" at the end of editing\n");
    out("[+] Also if you want more detiled guide on how it works and more read the docs I'm sure they will help you out\n\n");

    char filename[256];

    if (argc > 1) {
      string(filename, sizeof(filename), "%s", argv[1]);
    }
    else {
      out("Filename >> ");
      if (!fgets(filename, sizeof(filename), stdin)) {
        out("\n[+] Something fucked up while reading filename\n");
        return 1;
      }
      filename[strcspn(filename, "\n")] = 0;
    }

    enableRawMode();

    Buffer* buf = createBuffer();
    loadFile(filename, buf);

    int row = 0, col = 0;
    int viewportHeight = 25, viewportWidth = 80;
    int scrollOffset = 0;

    void renderWithColors(Buffer* buf, int row, int col, int scrollOffset, int viewportHeight, int viewportWidth, const char* filename) {
        clearScreen();
        int endLine = scrollOffset + viewportHeight;
        if (endLine > buf->size) endLine = buf->size;

        for (int i = scrollOffset; i < endLine; i++) {
            char lineNum[8];
            string(lineNum, sizeof(lineNum), "%4d ", i + 1);

            if (i == row) out("\033[7m");
            else out("\033[0m");

            out("\033[90m%s\033[0m", lineNum);

            if (i == row) out("\033[7m%s\033[0m\n", buf->lines[i]);
            else out("%s\n", buf->lines[i]);
        }

        for (int i = endLine; i < scrollOffset + viewportHeight; i++) {
            out("\033[90m%4d ~\033[0m\n", i + 1);
        }

        moveCursor(row - scrollOffset, col + 5);
        drawStatusBar(filename, row, col, buf->size, viewportWidth);
    }

    renderWithColors(buf, row, col, scrollOffset, viewportHeight, viewportWidth, filename);

    while (1) {
        char ch = getch();
        if (!ch) continue;

        if (ch == '\033') {
            char next1 = getch();
            if (next1 == '[') {
                char dir = getch();
                switch (dir) {
                    case 'A': if (row > 0) row--; break;
                    case 'B': if (row < buf->size - 1) row++; break;
                    case 'C': if (col < strlen(buf->lines[row])) col++; break;
                    case 'D': if (col > 0) col--; break;
                }
            } else {
                break;
            }
        } else if (ch == 3) {
            clearScreen();
            disableRawMode();
            out("Editor exited without saving.\n");
            freeBuffer(buf);
            return 0;
        } else if (ch == 127 || ch == 8) {
            if (col > 0) {
                memmove(&buf->lines[row][col - 1], &buf->lines[row][col], strlen(buf->lines[row]) - col + 1);
                col--;
            } else if (row > 0) {
                col = strlen(buf->lines[row - 1]);
                buf->lines[row - 1] = realloc(buf->lines[row - 1], strlen(buf->lines[row - 1]) + strlen(buf->lines[row]) + 1);
                strcat(buf->lines[row - 1], buf->lines[row]);
                free(buf->lines[row]);
                for (int i = row; i < buf->size - 1; i++) buf->lines[i] = buf->lines[i + 1];
                buf->size--;
                row--;
            }
        } else if (ch == '\n' || ch == '\r') {
            char* newLine = strdup(&buf->lines[row][col]);
            buf->lines[row][col] = '\0';
            buf->lines = realloc(buf->lines, sizeof(char*) * (buf->size + 1));
            for (int i = buf->size; i > row + 1; i--) buf->lines[i] = buf->lines[i - 1];
            buf->lines[row + 1] = newLine;
            buf->size++;
            row++;
            col = 0;
        } else if (isprint(ch)) {
            int len = strlen(buf->lines[row]);
            buf->lines[row] = realloc(buf->lines[row], len + 2);
            memmove(&buf->lines[row][col + 1], &buf->lines[row][col], len - col + 1);
            buf->lines[row][col] = ch;
            col++;
        }

        if (row < 0) row = 0;
        if (row >= buf->size) row = buf->size - 1;
        if (col < 0) col = 0;
        if (col > strlen(buf->lines[row])) col = strlen(buf->lines[row]);

        int half = viewportHeight / 2;
        if (row < half) scrollOffset = 0;
        else if (row > buf->size - half) scrollOffset = buf->size - viewportHeight;
        else scrollOffset = row - half;
        if (scrollOffset < 0) scrollOffset = 0;

        renderWithColors(buf, row, col, scrollOffset, viewportHeight, viewportWidth, filename);
    }

    disableRawMode();
    saveFile(filename, buf);
    clearScreen();
    out("File saved: %s\n", filename);

    char choice;
    out("Do you want to compile %s now? (y/n): ", filename);
    choice = getchar();
    if (tolower(choice) == 'y') {
        compileAndRun(filename);
    }

    freeBuffer(buf);
    out("\nExiting IDEK...\n");
    return 0;
}
