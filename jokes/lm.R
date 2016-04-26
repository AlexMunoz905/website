# This function is merely for fun
print("linearModel Usage:")
print("linearModel(y, X, weights = c(T, F))")
linearModel <- function (y, X, weights = c("T", "F")) {
    if (weights == "T") {
        warning("This function has not been implemented yet!")
    } else {
        return(lm(y ~ X))
    }
}
