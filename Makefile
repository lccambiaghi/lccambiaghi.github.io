EMACS := /Applications/Emacs.app/Contents/MacOS/Emacs

build:
	$(EMACS) --script publish.el

serve: build
	cd output && python -m http.server 8000	
