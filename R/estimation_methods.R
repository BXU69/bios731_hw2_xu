library(boot)

get_ci_methods <- function(data, B = 500, B_inner = 100) {
  
  # -------------------------
  # 1) Wald CI
  # -------------------------
  t0 <- proc.time()
  model <- lm(y ~ x1, data = data)
  beta_hat <- coef(model)["x1"]
  se_wald <- summary(model)$coefficients["x1", "Std. Error"]
  wald_ci <- c(beta_hat - 1.96 * se_wald, beta_hat + 1.96 * se_wald)
  time_wald <- (proc.time() - t0)[3]
  
  # -------------------------
  # 2) Percentile bootstrap CI
  #    (outer bootstrap only: fast)
  # -------------------------
  boot_stat_perc <- function(d, i) {
    d_sub <- d[i, ]
    coef(lm(y ~ x1, data = d_sub))["x1"]
  }
  
  t1 <- proc.time()
  boot_out_perc <- boot(data, statistic = boot_stat_perc, R = B)
  perc_ci <- boot.ci(boot_out_perc, type = "perc")$percent[4:5]
  time_perc <- (proc.time() - t1)[3]
  
  # -------------------------
  # 3) Bootstrap-t (studentized) CI
  #    (outer + inner bootstrap: slow)
  # -------------------------
  boot_stat_t <- function(d, i) {
    d_sub <- d[i, ]
    m_sub <- lm(y ~ x1, data = d_sub)
    b_star <- coef(m_sub)["x1"]
    
    inner_res <- replicate(B_inner, {
      d_inner <- d_sub[sample(nrow(d_sub), replace = TRUE), ]
      coef(lm(y ~ x1, data = d_inner))["x1"]
    })
    
    # Return (theta_star, var_star) for stud interval
    c(b_star, var(inner_res))
  }
  
  t2 <- proc.time()
  boot_out_t <- boot(data, statistic = boot_stat_t, R = B)
  t_ci <- boot.ci(boot_out_t, type = "stud")$student[4:5]
  time_boot_t <- (proc.time() - t2)[3]
  
  return(list(
    wald = wald_ci,
    perc = perc_ci,
    boot_t = t_ci,
    beta_hat = beta_hat,
    se_wald = se_wald,
    time_wald = time_wald,
    time_perc = time_perc,
    time_boot_t = time_boot_t
  ))
}