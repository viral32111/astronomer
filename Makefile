# Version
ASTRONOMER_MAJOR_VERSION = 0
ASTRONOMER_MINOR_VERSION = 1
ASTRONOMER_PATCH_VERSION = 0

# Variables
CC = gcc
CFLAGS = $(shell pkg-config --cflags gtk4 libcurl) -DASTRONOMER_MAJOR_VERSION=$(ASTRONOMER_MAJOR_VERSION) -DASTRONOMER_MINOR_VERSION=$(ASTRONOMER_MINOR_VERSION) -DASTRONOMER_PATCH_VERSION=$(ASTRONOMER_PATCH_VERSION)
LDFLAGS = $(shell pkg-config --libs gtk4 libcurl)
VERSION = $(ASTRONOMER_MAJOR_VERSION).$(ASTRONOMER_MINOR_VERSION).$(ASTRONOMER_PATCH_VERSION)
SOURCE = source/main.c
BIN_NAME = astronomer-$(VERSION)
SYMLINK_NAME = astronomer
BUILD_DIR = build

# Configuration dependant variables
CFLAGS_DEBUG = -Wall -Wextra -Wundef -Wformat-security -g
CFLAGS_RELEASE = -Wall -Wextra -Werror -Wundef -Wformat-security -O2

release: all
debug: all
run: run-release

debug: CFLAGS += $(CFLAGS_DEBUG)
debug: BUILD_DIR := $(BUILD_DIR)/debug
release: CFLAGS += $(CFLAGS_RELEASE)
release: BUILD_DIR := $(BUILD_DIR)/release
debug release: all

# Installation directories
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin

# Default target
all: $(BUILD_DIR)/$(BIN_NAME)

# Building the target
$(BUILD_DIR)/$(BIN_NAME): $(SOURCE)
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/$(BIN_NAME) $(SOURCE) $(LDFLAGS)
	ln -s -f $(BUILD_DIR)/$(BIN_NAME) $(BUILD_DIR)/$(SYMLINK_NAME)

# Run the application (debug)
run-debug: debug
	$(BUILD_DIR)/$(SYMLINK_NAME)

# Run the application (release)
run-release: release
	$(BUILD_DIR)/$(SYMLINK_NAME)

# Test the application
test: $(BUILD_DIR)/$(BIN_NAME)
	@echo "Tests are not implemented yet."

# Install the application
install: $(BUILD_DIR)/$(BIN_NAME)
	mkdir -p $(DESTDIR)$(BINDIR)
	install -m 755 $(BUILD_DIR)/$(BIN_NAME) $(DESTDIR)$(BINDIR)
	ln -s -f $(DESTDIR)$(BINDIR)/$(BIN_NAME) $(DESTDIR)$(BINDIR)/$(SYMLINK_NAME)

# Uninstall the application
uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(BIN_NAME)
	rm -f $(DESTDIR)$(BINDIR)/$(SYMLINK_NAME)

# Clean up
clean:
	rm -r -f $(BUILD_DIR)
