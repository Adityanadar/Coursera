## This functions are used to cache the inverse of a matrix

## This function creates a matrix object that can cache its inverse and its previous value 

makeCacheMatrix <- function(x = matrix()) {
	ix <- NULL
	prev_x <- NULL
	set <- function(y) {
		prev_x <<- x
		x <<- y
		ix <<- NULL
	}
	get <- function() x
	getPrevious <- function() prev_x
	setInverse <- function(inverse) ix <<- inverse
	getInverse <- function() ix
	list(set = set, get = get, getPrevious = getPrevious, setInverse = setInverse, getInverse = getInverse)
}


## This function returns the inverse of 'x' but first checks if the
## inverse has already been calculated and compares 'x' with its previous value

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
        ix <- x$getInverse()
        prev_x <- x$getPrevious()
        if(!is.null(ix) & identical(prev_x, x)) {
        	message("getting cached inverse matrix")
        	return(ix)
        }
        data <- x$get()
        ix <- solve(data)
        x$setInverse(ix)
        ix
}