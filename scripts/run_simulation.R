library(tidyverse)
library(boot)

# 1. Load functions using relative paths
source("R/generate_data.R")
source("R/estimation_methods.R")

# 2. Setup Factorial Design (18 Scenarios)
scenarios <- expand.grid(
  n = c(10, 50, 500),                   
  beta_treatment = c(0, 0.5, 2),       
  error_type = c("normal", "heavy"),  
  stringsAsFactors = FALSE
)

# 3. Parameters from HW requirements
n_sim <- 475       
B_outer <- 500     
B_inner <- 100
seed0 = 23
rep_id = as.integer(Sys.getenv("SLURM_ARRAY_TASK_ID"))

# 5. Run ALL scenarios, one replicate each
for (scenario_idx in 1:nrow(scenarios)) {
  
  scen <- scenarios[scenario_idx, ]
  
  # reproducible seed, different across (rep_id, scenario_idx)
  set.seed(seed0 + rep_id * 1000 + scenario_idx)
  
  dat <- generate_data(scen$n, scen$beta_treatment, scen$error_type)
  
  start_t <- proc.time()
  cis <- get_ci_methods(dat, B = B_outer, B_inner = B_inner)
  runtime <- (proc.time() - start_t)[3]
  
  res <- data.frame(
    scenario_idx   = scenario_idx,
    rep_id         = rep_id,
    n              = scen$n,
    beta_treatment = scen$beta_treatment,
    error_type     = scen$error_type,
    
    bias       = cis$beta_hat - scen$beta_treatment,
    cover_wald = as.numeric(scen$beta_treatment >= cis$wald[1] & scen$beta_treatment <= cis$wald[2]),
    cover_perc = as.numeric(scen$beta_treatment >= cis$perc[1] & scen$beta_treatment <= cis$perc[2]),
    cover_t    = as.numeric(scen$beta_treatment >= cis$boot_t[1] & scen$beta_treatment <= cis$boot_t[2]),
    se_val     = cis$se_wald,
    
    time_wald   = cis$time_wald,
    time_perc   = cis$time_perc,
    time_boot_t = cis$time_boot_t,
    
    runtime = runtime
  )
  
  # Save: one file per replicate per scenario
  scenario_id <- sprintf("n%s_beta%s_%s", scen$n, scen$beta_treatment, scen$error_type)
  out_dir <- file.path("data", "reps", scenario_id)
  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
  
  out_file <- file.path(out_dir, sprintf("rep_%04d.Rds", rep_id))
  saveRDS(res, file = out_file)
  
  cat("Saved:", out_file, "\n")
}