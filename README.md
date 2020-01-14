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
