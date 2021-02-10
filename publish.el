;;; publish.el --- Generate a simple static HTML blog
;;; Commentary:
;;
;;    Define the routes of the static website.  Each of which
;;    containing the pattern for finding Org-Mode files, which HTML
;;    template to be used, as well as their output path and URL.
;;
;;; Code:

(if (string= (getenv "ENV") "prod")
    (setq weblorg-default-url "https://luca.cambiaghi.me"))
(if (string= (getenv "ENV") "local")
    (setq weblorg-default-url "http://localhost:8000"))

(defun init-site ()
	(weblorg-site
	 ;; :theme "autodoc"
	 :template-vars '(("project_name" . "lccambiaghi")
										("project_github" . "https://github.com/lccambiaghi/lccambiaghi")
										("project_description" . "Luca's blog"))
	 )

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

(init-site)
(weblorg-export)
;;; publish.el ends here
