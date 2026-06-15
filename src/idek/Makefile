CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17 -O3
TARGET = idek
SRCS = main.cpp terminal.cpp file_io.cpp renderer.cpp
OBJS = $(SRCS:.cpp=.o)

# The default target builds the executable
all: $(TARGET)

# Link the object files into the final binary
$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS)

# Compile individual source files into object files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean up build artifacts manually
clean:
	rm -f $(OBJS) $(TARGET)

# One-shot build: compiles everything and instantly deletes the .o files
oneshot:
	$(CXX) $(CXXFLAGS) $(SRCS) -o $(TARGET)

.PHONY: all clean oneshot
