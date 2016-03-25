capitalize <- function(txt) {
	letters = strsplit(txt, '')[[1]]
	idx = c(1,which(letters == ' ') + 1)
	letters[idx] = toupper(letters[idx])
	paste(letters,collapse='')
}

rankhospital <- function(state, outcome, num = "best") {
	ocm <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
	if (state %in% ocm$State) {
		sub_ocm <- subset(ocm, ocm$State == state)
		outcome_title <- paste(strsplit(capitalize(outcome), " ")[[1]], collapse=".")
		if (outcome_title %in% c('Heart.Attack', 'Heart.Failure', 'Pneumonia')) {
			sub_main_ocm <- subset(sub_ocm, select = c('Hospital.Name', paste('Hospital.30.Day.Death..Mortality..Rates.from', outcome_title, sep=".")))
			sub_main_ocm[[2]] = suppressWarnings(as.numeric(sub_main_ocm[[2]]))
			ordered_ocm <- with(sub_main_ocm, sub_main_ocm[order(sub_main_ocm[,2], sub_main_ocm[,1], na.last = NA),])
			if (num == "best") {
				ordered_ocm$Hospital.Name[1]					
			} else if (num == 'worst') {
				ordered_ocm$Hospital.Name[nrow(ordered_ocm)]						
			} else if (is.numeric(num) && num > 0) {
				ordered_ocm$Hospital.Name[num]				
			} else {
				stop('invalid num')					
			}		
		} else {
			stop('invalid outcome')			
		}
	} else {
		stop('invalid state')		
	}
}