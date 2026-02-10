ci_boot_percentile <- function(dat, B = 500, level = 0.95, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  n <- nrow(dat)
  
  theta_star <- numeric(B)
  for (b in seq_len(B)) {
    idx <- sample.int(n, size = n, replace = TRUE)
    fb <- fit_lm_trt(dat[idx, , drop = FALSE])
    theta_star[b] <- fb$beta_hat
  }
  
  alpha <- 1 - level
  qs <- quantile(theta_star, probs = c(alpha/2, 1 - alpha/2), names = FALSE)
  c(lwr = qs[1], upr = qs[2])
}
