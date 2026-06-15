# Variables for compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -O2
LDFLAGS = -pthread

# Name of the final executable
TARGET = port_scan

# The default rule that runs when you just type 'make'
all: $(TARGET)

# Rule to link the object file and create the executable
$(TARGET): port_scan.o
	$(CC) $(CFLAGS) port_scan.o -o $(TARGET) $(LDFLAGS)

# Rule to compile the source file into an object file
port_scan.o: port_scan.c
	$(CC) $(CFLAGS) -c port_scan.c

# Rule to clean up compiled files
clean:
	rm -f *.o $(TARGET)
