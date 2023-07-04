# Variables
CC = gcc
CFLAGS = -Wall $(shell pkg-config --cflags gtk4 libcurl)
LDFLAGS = $(shell pkg-config --libs gtk4 libcurl)
SOURCE = source/main.c
BIN_NAME = astronomer
BUILD_DIR = build

# Installation directories
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin

# Default target
all: $(BUILD_DIR)/$(BIN_NAME)

# Building the target
$(BUILD_DIR)/$(BIN_NAME):
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/$(BIN_NAME) $(SOURCE) $(LDFLAGS)

# Install the application
install: $(BUILD_DIR)/$(BIN_NAME)
	mkdir -p $(DESTDIR)$(BINDIR)
	install -m 755 $(BUILD_DIR)/$(BIN_NAME) $(DESTDIR)$(BINDIR)

# Uninstall the application
uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(BIN_NAME)

# Clean up
clean:
	rm -r -f $(BUILD_DIR)
