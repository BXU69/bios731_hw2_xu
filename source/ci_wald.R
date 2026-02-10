ci_wald <- function(beta_hat, se_hat, level = 0.95) {
  alpha <- 1 - level
  z <- qnorm(1 - alpha / 2)
  c(lwr = beta_hat - z * se_hat,
    upr = beta_hat + z * se_hat)
}
