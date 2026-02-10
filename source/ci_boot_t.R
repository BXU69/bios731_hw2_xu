ci_boot_t <- function(dat, B = 500, B_inner = 100, level = 0.95, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  n <- nrow(dat)
  
  f0 <- fit_lm_trt(dat)
  theta_hat <- f0$beta_hat
  se_hat <- f0$se_hat
  
  theta_star <- numeric(B)
  se_star <- numeric(B)
  
  for (b in seq_len(B)) {
    idx <- sample.int(n, size = n, replace = TRUE)
    dat_b <- dat[idx, , drop = FALSE]
    
    fb <- fit_lm_trt(dat_b)
    theta_star[b] <- fb$beta_hat
    
    theta_inner <- numeric(B_inner)
    for (j in seq_len(B_inner)) {
      idx2 <- sample.int(n, size = n, replace = TRUE)
      fin <- fit_lm_trt(dat_b[idx2, , drop = FALSE])
      theta_inner[j] <- fin$beta_hat
    }
    se_star[b] <- sd(theta_inner)
  }
  
  t_star <- (theta_star - theta_hat) / se_star
  
  alpha <- 1 - level
  q_hi <- quantile(t_star, probs = 1 - alpha/2, names = FALSE)
  q_lo <- quantile(t_star, probs = alpha/2, names = FALSE)
  
  c(lwr = theta_hat - q_hi * se_hat,
    upr = theta_hat - q_lo * se_hat)
}
