generate_data <- function(n, beta_treatment, error_type) {
  error_type = match.arg(error_type, choices = c("normal", "heavy"))
  x1 <- rbinom(n, 1, 0.5)
  
  if (error_type == "normal") {
    errors <- rnorm(n, mean = 0, sd = sqrt(2)) 
  } else {
    nu <- 3
    u <- rt(n, df = nu)
    errors <- u * sqrt(2 * (nu - 2) / nu)
  }
  
  y <- 0 + beta_treatment * x1 + errors 
  return(data.frame(y = y, x1 = x1))
}