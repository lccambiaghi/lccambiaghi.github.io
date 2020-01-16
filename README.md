Inside Rstudio:
`
Sys.getenv("RSTUDIO_PANDOC") # "/Applications/RStudio.app/Contents/MacOS/pandoc"
`

Render website:
`
Rscript -e 'Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc"); rmarkdown::render_site()'
`

Clean:
`
Rscript -e 'Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc"; rmarkdown::clean_site()'
`

Create a ~distill~ blog post:
`
Rscript -e 'library(distill); create_post("example")'
`

Render a post with `knit+pandoc`:
`
Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc"); rmarkdown::render("_posts/2020-01-01-example/example.Rmd")
`
