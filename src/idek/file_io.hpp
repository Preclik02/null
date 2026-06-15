#pragma once
#include <string>
#include <vector>

void loadFile(const std::string& filename, std::vector<std::string>& buffer);
void saveFile(const std::string& filename, const std::vector<std::string>& buffer);
