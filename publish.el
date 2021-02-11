;;; publish.el --- Generate a simple static HTML blog

(defun setup-deps ()
	;; Setup package management
	(require 'package)
	(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
	(package-initialize)
	(unless (package-installed-p 'use-package)
		(package-refresh-contents)
		(package-install 'use-package))

	;; Install and configure dependencies
	(use-package templatel :ensure t)
	(use-package htmlize :ensure t)
	(setq org-html-htmlize-output-type 'css)
	(use-package weblorg :ensure t)
	;; code blocks syntax highlight
	(use-package clojure-mode :ensure t)
	)

(defun setup-site ()
	(when (string= (getenv "ENV") "GHUB")
		(setup-deps)
	  (setq weblorg-default-url "https://lccambiaghi.github.io")) ;; default is localhost:8000

	(weblorg-site
	 :base-url weblorg-default-url
	 :template-vars '(("project_name" . "lccambiaghi")
										("project_github" . "https://github.com/lccambiaghi/lccambiaghi")
										("project_description" . "Luca's blog")))

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

	(weblorg-copy-static
	 :output "output/static/{{ file }}"
	 :url "/static/{{ file }}")
	)

(setup-site)
(weblorg-export)

;;; publish.el ends here
