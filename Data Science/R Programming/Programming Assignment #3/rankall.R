rankall <- function(outcome, num = 'best') {
	ocm <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
	unique_states <- sort(unique(ocm$State))
	hospitals_per_state <- as.character()
	if (tolower(outcome) == 'heart attack') {
		outcome_index <- 11
	} else if (tolower(outcome) == 'heart failure') {
		outcome_index <- 17	
	} else if (tolower(outcome) == 'pneumonia') {
		outcome_index <- 23	
	} else {
		stop('invalid outcome')		
	}
	for (state in unique_states) {
		data_per_state <- subset(ocm, ocm$State == state)
		data_per_state[, outcome_index] = suppressWarnings(as.numeric(data_per_state[, outcome_index]))
		ordered_data <- data_per_state[order(data_per_state[, outcome_index], data_per_state$Hospital.Name, na.last = NA),]
		if (tolower(num) == 'best') {
			hospitals_per_state <- c(hospitals_per_state, ordered_data$Hospital.Name[1])				
		} else if (tolower(num) == 'worst') {
			hospitals_per_state <- c(hospitals_per_state, ordered_data$Hospital.Name[nrow(ordered_data)])					
		} else if (is.numeric(num) && num > 0) {
			hospitals_per_state <- c(hospitals_per_state, ordered_data$Hospital.Name[num])			
		} else {
			stop('invalid num')					
		}
	}
	return (data.frame(hospital = hospitals_per_state, state = unique_states, stringsAsFactors = FALSE))
}