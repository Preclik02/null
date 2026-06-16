# Competent Compilers
CC       := gcc
CXX      := g++
CFLAGS   := -Wall -Wextra -O2
CXXFLAGS := -Wall -Wextra -O2 -std=c++17

# Target Binaries
C_UTILS   := figlet/figlet jayfetch/jayfetch mode/mode todo/todo
SUBDIR_TARGETS := idek/idek null/null port_scan/port_scan

# All binaries we want to produce
TARGETS := $(C_UTILS) $(SUBDIR_TARGETS)

.PHONY: all clean $(SUBDIR_TARGETS)

# Default rule builds everything
all: $(TARGETS)

# Rule for simple single-file C utilities
figlet/figlet: figlet/figlet.c
	$(CC) $(CFLAGS) $< -o $@

jayfetch/jayfetch: jayfetch/jayfetch.c
	$(CC) $(CFLAGS) $< -o $@

mode/mode: mode/mode.c
	$(CC) $(CFLAGS) $< -o $@

todo/todo: todo/todo.c
	$(CC) $(CFLAGS) $< -o $@

# Rules to delegate building to directories with their own Makefiles
idek/idek:
	$(MAKE) -C idek

null/null:
	$(MAKE) -C null

port_scan/port_scan:
	$(MAKE) -C port_scan

# Clean rule to wipe the slate clean across all directories
clean:
	@echo "Cleaning up binaries and object files..."
	rm -f $(C_UTILS)
	$(MAKE) -C idek clean || rm -f idek/*.o idek/idek
	$(MAKE) -C null clean || rm -f null/*.o null/null
	$(MAKE) -C port_scan clean || rm -f port_scan/*.o port_scan/port_scan
