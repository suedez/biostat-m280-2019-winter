#########################
# Makefile
# This is a silly imitation of Goring's Makefile by suedez
################

 hw2sol: ./hw2/hw2sol.Rmd
 	Rscript -e 'rmarkdown::render(c("$<"))'

 	clean:
 		rm -rf *.html *.md *.docx figure/ cache/
