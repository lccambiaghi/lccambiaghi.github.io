.DEFAULT_GOAL := build
EMACS := /opt/homebrew/bin/emacs
SITES_DIR := /Users/cambiaghiluca/Sites
SITES_DIR := /Library/WebServer/Documents

clean:
	rm -rf $(SITES_DIR)/*

build: clean
	$(EMACS) --script publish.el
	cp -r output/* $(SITES_DIR)/
	open -a Safari http://localhost/index.html

setup:
	sudo chmod -R o+w $(SITES_DIR)
	mkdir -p $(SITES_DIR)
