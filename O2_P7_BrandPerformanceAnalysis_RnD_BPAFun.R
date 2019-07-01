
BrandPerformanceAnalysis = function(){

list.of.packages = c("rmarkdown","dplyr","tidyr", "knitr" ) # replace xx and yy with package names
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages) > 0) {install.packages(new.packages)}
lapply(list.of.packages, require, character.only=T)



OutputFile = paste("//192.168.2.32/Group/Data Team/Brand_Update_Location/2_Output_Folder/","BPA_",gsub(' ','',trimws( Sys.Date())),".html", sep="")

rmarkdown::render("//192.168.2.32/Group/Data Team/Abul/1. Development/1. FunctionalTools/R/1. ProductionReady/5. BrandPerformanceAnalysis/V1.0_BPA_Report.Rmd", 
	output_file=OutputFile , 'html_document')

}

