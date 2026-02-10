run_one_sim <- function(n, beta_trt, err,
                        B = 500, B_inner = 100, level = 0.95,
                        seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  
  dat <- gen_data(n = n, beta_trt = beta_trt, err = err)
  f0 <- fit_lm_trt(dat)
  
  t_wald <- system.time({
    ci1 <- ci_wald(f0$beta_hat, f0$se_hat, level = level)
  })[["elapsed"]]
  
  t_perc <- system.time({
    ci2 <- ci_boot_percentile(dat, B = B, level = level)
  })[["elapsed"]]
  
  t_bt <- system.time({
    ci3 <- ci_boot_t(dat, B = B, B_inner = B_inner, level = level)
  })[["elapsed"]]
  
  data.frame(
    beta_hat = f0$beta_hat,
    se_hat   = f0$se_hat,
    
    wald_lwr = ci1["lwr"], wald_upr = ci1["upr"],
    perc_lwr = ci2["lwr"], perc_upr = ci2["upr"],
    bt_lwr   = ci3["lwr"], bt_upr   = ci3["upr"],
    
    cover_wald = (ci1["lwr"] <= beta_trt && beta_trt <= ci1["upr"]),
    cover_perc = (ci2["lwr"] <= beta_trt && beta_trt <= ci2["upr"]),
    cover_bt   = (ci3["lwr"] <= beta_trt && beta_trt <= ci3["upr"]),
    
    time_wald = t_wald,
    time_perc = t_perc,
    time_bt   = t_bt
  )
}
