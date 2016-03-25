pollutantmean <- function(directory, pollutant, id = 1:332) {
	mean_vector <- c()
	for (i in id) {
		my_data <- read.csv(file.path(directory,sprintf("%03d.csv", i)))
		mean_vector <- c(mean_vector, my_data[[pollutant]])
	}
	return (mean(mean_vector, na.rm = TRUE))
}