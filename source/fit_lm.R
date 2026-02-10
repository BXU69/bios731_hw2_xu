fit_lm_trt <- function(dat) {
  fit <- lm(y ~ x1, data = dat)
  coefs <- summary(fit)$coefficients
  list(
    beta_hat = unname(coefs["x1", "Estimate"]),
    se_hat   = unname(coefs["x1", "Std. Error"])
  )
}
