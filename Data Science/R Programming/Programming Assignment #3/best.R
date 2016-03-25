capitalize <- function(txt) {
	letters = strsplit(txt, '')[[1]]
	idx = c(1,which(letters == ' ') + 1)
	letters[idx] = toupper(letters[idx])
	paste(letters,collapse='')
}

best <- function(state, outcome) {
	ocm <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
	if (state %in% ocm$State) {
		sub_ocm <- subset(ocm, ocm$State == state)
		sub_ocm_lower <- sub_ocm[grepl('Lower.Mortality', colnames(sub_ocm))]
		outcome_title <- paste(strsplit(capitalize(outcome), " ")[[1]], collapse=".")	
		if ('TRUE' %in% grepl(outcome_title, colnames(sub_ocm_lower))) {
			data <- suppressWarnings(as.numeric(sub_ocm_lower[grepl(outcome_title, colnames(sub_ocm_lower))][[1]]))
			sort(sub_ocm$Hospital.Name[which(data == min(data, na.rm = TRUE))])[1]
		} else {
			stop('invalid outcome')
		}
	} else {
		stop('invalid state')		
	}
}