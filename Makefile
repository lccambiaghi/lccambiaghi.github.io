.DEFAULT_GOAL := build
EMACS := /Applications/Emacs.app/Contents/MacOS/Emacs
SITES_DIR := /Users/luca/Sites

clean:
	rm -rf $(SITES_DIR)/*

build: clean
	$(EMACS) --script publish.el
	cp -r output/* $(SITES_DIR)/
	open -a Safari http://localhost/index.html
