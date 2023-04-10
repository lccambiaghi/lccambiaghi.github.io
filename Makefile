.DEFAULT_GOAL := build
EMACS := /opt/homebrew/bin/emacs
SITES_DIR := /Library/WebServer/Documents

clean:
	rm -rf $(SITES_DIR)/*

build: clean
	$(EMACS) --script publish.el
	cp -r output/* $(SITES_DIR)/
	open -a Safari http://localhost/index.html

setup:
	mkdir -p $(SITES_DIR)
	sudo chmod -R o+w $(SITES_DIR)
	sudo apachectl start
