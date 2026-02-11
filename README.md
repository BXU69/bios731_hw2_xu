# BIOS 731 HW2 — Simulation Study (CI Methods)

## Overview
This project runs a Monte Carlo simulation to compare three 95% confidence interval (CI) methods for the treatment effect in a simple linear regression:

- Wald CI
- Bootstrap percentile CI
- Bootstrap-t (studentized) CI

We evaluate:
- Bias of beta_hat
- Empirical coverage of the 95% CI
- Distribution of se(beta_hat) from `lm()`
- Computation time across CI methods

Full factorial design (18 scenarios):
- Sample size: n ∈ {10, 50, 500}
- True effect: beta_treatment ∈ {0, 0.5, 2}
- Error type: normal vs heavy-tailed (t3)

Replicates per scenario: 475  
Total runs: 18 × 475 = 8550

---

## Key Files
- `BIOS731HW2_FinalReport.Rmd` : final report source (R Markdown)
- `BIOS731HW2_FinalReport.pdf` : compiled report
- `HW_simulation-1.pdf` : homework instructions

---

## Code Organization
**Core functions**
- `R/generate_data.R`  
  Generates simulated data under the specified scenario.

- `R/estimation_methods.R`  
  Computes:
  - Wald CI
  - Bootstrap percentile CI
  - Bootstrap-t CI  
  Also records runtime for each method.

**Cluster execution**
- `scripts/run_simulation.R`  
  Runs the simulation for one SLURM array replicate.  
  In each replicate, it loops over all 18 scenarios and saves one `.Rds` file per scenario.

---

## Output
Simulation outputs are written to:
- `data/reps/`

File naming convention:
- Each scenario has its own folder: `data/reps/<scenario_id>/`
- Each replicate produces one file: `rep_XXXX.Rds`

Example pattern:
- `data/reps/n10_beta0_normal/rep_0001.Rds`

This design is restart-safe and avoids overwriting results.

---

## Running on the Cluster (SLURM)
The full simulation was executed on a computing cluster using SLURM array jobs.

Submission script:
- `submit_sim.sh`

Command used:
- `sbatch --array=1-475 submit_sim.sh`

Meaning:
- Each SLURM array index (`SLURM_ARRAY_TASK_ID`) corresponds to one replicate ID.
- Each replicate runs all 18 scenarios once.
- Total scenario evaluations = 475 × 18 = 8550.

---

## Aggregating Results (in the report)
In `BIOS731HW2_FinalReport.Rmd`, results are aggregated by reading all `.Rds` files from `data/reps/` and summarizing by scenario.

Typical steps:
1. Read all replicate files
2. Combine into one data frame
3. Summarize bias / coverage / SE distribution / runtime
4. Produce plots and tables for the report

---

## Reproducibility Notes
- Seeds are controlled per replicate (via SLURM array index).
- Each replicate is independent.
- All results are saved before aggregation.

---

## Author
Xu (BIOS 731, Emory University)