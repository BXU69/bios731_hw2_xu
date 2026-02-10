#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
})

# ---- helper: parse --key=value arguments ----
get_arg_value <- function(key) {
  args <- commandArgs(trailingOnly = TRUE)
  pat <- paste0("^--", key, "=")
  hit <- grep(pat, args, value = TRUE)
  if (length(hit) == 0) return(NULL)
  sub(pat, "", hit[1])
}

`%||%` <- function(x, y) if (!is.null(x) && length(x) > 0 && x != "") x else y

# ---- scenario id priority: cli > env > slurm array ----
scenario_id <- get_arg_value("scenario_id")
scenario_id <- scenario_id %||% Sys.getenv("SCENARIO_ID", unset = "")
scenario_id <- scenario_id %||% Sys.getenv("SLURM_ARRAY_TASK_ID", unset = "")
if (scenario_id == "") stop("No scenario id provided (use --scenario_id=, SCENARIO_ID, or SLURM_ARRAY_TASK_ID).")
scenario_id <- as.integer(scenario_id)

# ---- constants (overridable via cli/env) ----
nsim <- as.integer(get_arg_value("nsim") %||% Sys.getenv("NSIM", "500"))
B <- as.integer(get_arg_value("B") %||% Sys.getenv("B", "500"))
B_inner <- as.integer(get_arg_value("B_inner") %||% Sys.getenv("B_INNER", "100"))
level <- as.numeric(get_arg_value("level") %||% Sys.getenv("LEVEL", "0.95"))
seed_base <- as.integer(get_arg_value("seed") %||% Sys.getenv("SEED_BASE", "2026"))

# ---- source all functions from source/ ----
source("source/gen_data.R")
source("source/fit_lm.R")
source("source/ci_wald.R")
source("source/ci_boot_percentile.R")
source("source/ci_boot_t.R")
source("source/run_one_sim.R")
source("source/run_scenario.R")
source("source/make_grid.R")

grid <- make_grid()
n_sc <- nrow(grid)

if (scenario_id < 1 || scenario_id > n_sc) {
  stop(sprintf("scenario_id must be in 1..%d, got %d", n_sc, scenario_id))
}

sc <- grid[scenario_id, ]

dir.create("data", showWarnings = FALSE, recursive = TRUE)

message(sprintf("Running scenario %d/%d: n=%d, beta_trt=%s, err=%s",
                scenario_id, n_sc, sc$n, sc$beta_trt, sc$err))

res <- run_scenario(
  n = sc$n,
  beta_trt = sc$beta_trt,
  err = sc$err,
  nsim = nsim,
  B = B,
  B_inner = B_inner,
  level = level,
  seed = seed_base + scenario_id
)

res$scenario_id <- scenario_id

out_file <- sprintf("data/scenario_%02d_n%d_b%s_%s.rds",
                    scenario_id, sc$n, sc$beta_trt, sc$err)

saveRDS(res, out_file)
message(sprintf("Saved: %s", out_file))
