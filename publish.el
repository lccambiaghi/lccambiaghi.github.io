;;; publish.el --- Generate a simple static HTML blog
(defun init-use-package ()
	(require 'package)
	(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
	(package-initialize)
	(unless (package-installed-p 'use-package)
		(package-refresh-contents)
		(package-install 'use-package)))

(defun setup-deps-github ()
	(init-use-package)
	;; Install and configure dependencies
	(use-package templatel :ensure t)
	(use-package htmlize :ensure t)
	(setq org-html-htmlize-output-type 'css)
	(use-package weblorg :ensure t)
	;; code blocks syntax highlight
	(use-package clojure-mode :ensure t)
	(use-package nix-mode :ensure t)
	;; set github URL
	(setq weblorg-default-url "https://luca.cambiaghi.me")
	)

(defun setup-deps-local ()
	(load (concat (getenv "HOME") "/.emacs.d/straight/repos/templatel/templatel.el"))
	(load (concat (getenv "HOME") "/.emacs.d/straight/repos/emacs-htmlize/htmlize.el"))
	(load (concat (getenv "HOME") "/.emacs.d/straight/repos/weblorg/weblorg.el"))
	(load (concat (getenv "HOME") "/.emacs.d/straight/repos/clojure-mode/clojure-mode.el"))
	(add-to-list 'load-path (concat (getenv "HOME") "/.emacs.d/straight/repos/nix-mode"))
	(load (concat (getenv "HOME") "/.emacs.d/straight/repos/nix-mode/nix-mode.el"))
	(setq org-html-htmlize-output-type 'css)
	(setq weblorg-default-url "http://localhost") 	;; "http://localhost:8000"
	)

(defun setup-site ()
	(if (string= (getenv "ENV") "GHUB")
			(setup-deps-github)
		(setup-deps-local))

	(setq site-template-vars '(("project_github" . "https://github.com/lccambiaghi/lccambiaghi")
														 ;; ("static_path" . "$site/static")
														 ("site_author" . "Luca Cambiaghi")
														 ("site_name" . "Luca's blog")
														 ("site_url" . "https://luca.cambiaghi.me")
														 ("site_email" . "luca.cambiaghi@me.com")
														 ("project_description" . "Luca's blog")))

	(weblorg-site
	 :base-url weblorg-default-url
	 :template-vars site-template-vars)

	(weblorg-route
	 :name "posts"
	 :input-pattern "posts/*.org"
	 :template "post.html"
	 :output "output/posts/{{ slug }}.html"
	 :url "/posts/{{ slug }}.html")

	;; route for rendering the index page of the blog
	(weblorg-route
	 :name "index"
	 :input-pattern "posts/*.org"
	 :input-aggregate #'weblorg-input-aggregate-all-desc
	 :template "blog.html"
	 :output "output/index.html"
	 :url "/")

	;; route for rendering each page
	(weblorg-route
	 :name "pages"
	 :input-pattern "pages/*.org"
	 :template "page.html"
	 :output "output/{{ slug }}.html"
	 :url "/{{ slug }}.html")

	(weblorg-route
	 :name "feed"
	 :input-pattern "posts/*.org"
	 :input-aggregate #'weblorg-input-aggregate-all-desc
	 :template "feed.xml"
	 :output "output/feed.xml"
	 :url "/feed.xml"
	 :template-vars site-template-vars
	 )

	(weblorg-copy-static
	 :output "output/static/{{ file }}"
	 :url "/static/{{ file }}")
	)

(setup-site)
(weblorg-export)

;;; publish.el ends here
