#include "file_io.hpp"
#include <fstream>

void loadFile(const std::string& filename, std::vector<std::string>& buffer) {
    std::ifstream file(filename);
    std::string line;
    if (file.is_open()) {
        while (std::getline(file, line)) {
            buffer.push_back(line);
        }
        file.close();
    }
    if (buffer.empty()) {
        buffer.push_back("");
    }
}

void saveFile(const std::string& filename, const std::vector<std::string>& buffer) {
    std::ofstream file(filename);
    for (const auto& line : buffer) {
        file << line << "\n";
    }
    file.close();
}
