# deploy:
# 	clean
# 	render

render:
	Rscript -e 'rmarkdown::render_site()'

clean:
	Rscript -e 'rmarkdown::clean_site()'
