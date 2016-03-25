corr <- function(directory, threshold = 0) {
	comp_cases <- complete(directory)
	above_threshold <- comp_cases["nobs"] > threshold
	vector <- comp_cases[above_threshold,]
	corr_vector = numeric()
	for (i in vector[["id"]]) {
		my_data <- read.csv(file.path(directory,sprintf("%03d.csv", i)))
		corr_vector <- c(corr_vector, cor(my_data[["nitrate"]], my_data[["sulfate"]], use = "complete.obs"))
	}
	return (corr_vector)
}