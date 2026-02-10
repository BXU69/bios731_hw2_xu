run_scenario <- function(n, beta_trt, err,
                         nsim = 500,
                         B = 500, B_inner = 100, level = 0.95,
                         seed = 1) {
  set.seed(seed)
  
  sims <- vector("list", nsim)
  for (s in seq_len(nsim)) {
    sims[[s]] <- run_one_sim(
      n = n, beta_trt = beta_trt, err = err,
      B = B, B_inner = B_inner, level = level,
      seed = sample.int(1e9, 1)
    )
  }
  
  df <- dplyr::bind_rows(sims)
  df$n <- n
  df$beta_trt <- beta_trt
  df$err <- err
  df$sim_id <- seq_len(nsim)
  df
}
