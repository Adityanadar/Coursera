complete <- function(directory, id = 1:332) {
	df = data.frame(id = numeric(), nobs = numeric())
	for (i in id) {
		my_data <- read.csv(file.path(directory,sprintf("%03d.csv", i)))
		df <- rbind(df, data.frame(id = i, nobs = sum(complete.cases(my_data))))
	}
	return (df)	
}