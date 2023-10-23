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
  (use-package dash :ensure t)
  (use-package templatel :ensure t)
  (use-package htmlize :ensure t)
  (setq org-html-htmlize-output-type 'css)
  (use-package weblorg :ensure t)
  ;; code blocks syntax highlight
  (use-package clojure-mode :ensure t)
  (use-package nix-mode :ensure t)
  ;; set github URL
  (setq weblorg-default-url "https://lucacambiaghi.com")
  )

(defun suppress-indentation-message ()
  (require 'cl-lib)
  (advice-add 'sh-set-shell :around
              (lambda (orig-fun &rest args)
                (cl-letf (((symbol-function 'message) #'ignore))
                  (apply orig-fun args)))))

(defun return-subdir-path (subdir-substring dir)
  "Return full path to subdir"
  (let ((subdir (car (directory-files dir t subdir-substring))))
    (if subdir
        (expand-file-name subdir)
      nil)))

(setq elpa-base-dir "~/.config/emacs/elpa/")

(defun use-org-id-links-in-weblorg-export ()
  (defun weblorg--parse-org (input-data &optional input-path)
    (let (html keywords)
      (advice-add
       #'org-html-template :override
       (lambda(contents _i) (setq html contents)))
      (advice-add
       #'org-html-keyword :before
       (lambda(keyword _c _i)
         (weblorg--prepend
          keywords
          (weblorg--parse-org-keyword keyword))))
      (with-temp-buffer
        (insert input-data)
        (if input-path (set-visited-file-name input-path t t))
        (org-html-export-as-html))
      (ad-unadvise 'org-html-template)
      (ad-unadvise 'org-html-keyword)
      (ad-unadvise 'org-element-property)
      (weblorg--prepend keywords (cons "html" html))
      keywords)))

(defun setup-deps-local ()
  (require 'subr-x)
  (thread-first
    "templatel" (return-subdir-path elpa-base-dir) (concat "/templatel.el") (load))

  (thread-first
    "htmlize" (return-subdir-path elpa-base-dir) (concat "/htmlize.el" ) (load))
  (setq org-html-htmlize-output-type 'css)

  (thread-first
    "weblorg" (return-subdir-path elpa-base-dir) (concat "/weblorg.el" ) (load))

  (thread-first
    "clojure-mode" (return-subdir-path elpa-base-dir) (concat "/clojure-mode.el" ) (load))

  (thread-first
    "dash" (return-subdir-path elpa-base-dir) (concat "/dash.el" ) (load))

  (thread-first
    "magit-section" (return-subdir-path elpa-base-dir) (concat "/magit-section.el" ) (load))

  (add-to-list 'load-path (return-subdir-path "nix-mode" elpa-base-dir))
  (thread-first
    "nix-mode" (return-subdir-path elpa-base-dir) (concat "/nix-mode.el" ) (load))

  (setq weblorg-default-url "http://localhost")
  (suppress-indentation-message)
  )

(defun setup-site ()
  (if (string= (getenv "ENV") "GHUB")
      (setup-deps-github)
    (setup-deps-local))

  (setq site-template-vars '(("project_github" . "https://github.com/lccambiaghi/lccambiaghi")
                             ;; ("static_path" . "$site/static")
                             ("site_author" . "Luca Cambiaghi")
                             ("site_name" . "Luca's blog")
                             ("site_url" . "https://lucacambiaghi.com")
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

  ;; route for rendering the posts page of the blog
  (weblorg-route
   :name "blog"
   :input-pattern "posts/*.org"
   :input-aggregate #'weblorg-input-aggregate-all-desc
   :template "blog.html"
   :output "output/posts.html"
   :url "/posts.html")

  ;; route for rendering each page
  (weblorg-route
   :name "pages"
   :input-pattern "pages/*.org"
   :input-exclude "pages/index.org"
   :template "page.html"
   :output "output/{{ slug }}.html"
   :url "/{{ slug }}.html")

  (weblorg-route
   :name "index"
   :input-pattern "pages/index.org"
   :template "index.html"
   :output "output/{{ slug }}.html"
   :url "/")

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

(require 'advice)
(use-org-id-links-in-weblorg-export)
(weblorg-export)

;;; publish.el ends here
