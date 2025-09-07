# Makefile for s3-secrets-sync

PREFIX ?= /usr/local
VERSION := 1.0.0

.PHONY: install uninstall update clean

all:
	@echo "Run 'make install' to install s3-secrets-sync"

install:
	@echo "Installing s3-secrets-sync to $(PREFIX)/bin"
	@mkdir -p $(PREFIX)/bin
	@cp s3-secrets-sync $(PREFIX)/bin/s3-secrets-sync
	@chmod +x $(PREFIX)/bin/s3-secrets-sync
	@echo "VERSION=$(VERSION)" > $(PREFIX)/bin/s3-secrets-sync.version
	@echo "Installation complete. Run 's3-secrets-sync --help' for usage information"

uninstall:
	@echo "Removing s3-secrets-sync from $(PREFIX)/bin"
	@rm -f $(PREFIX)/bin/s3-secrets-sync
	@rm -f $(PREFIX)/bin/s3-secrets-sync.version
	@echo "Uninstallation complete"

update: install
	@echo "Update complete"

clean:
	@echo "Cleaning up temporary files"
	@rm -f *.json *.enc *.bak
	@echo "Cleanup complete"
