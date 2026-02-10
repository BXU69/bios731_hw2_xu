#!/bin/bash
#SBATCH --job-name=hw2_boot
#SBATCH --output=logs/hw2_%A_%a.out
#SBATCH --error=logs/hw2_%A_%a.err
#SBATCH --time=08:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --array=1-18

# Optional (edit to match your cluster)
# #SBATCH --partition=compute
# #SBATCH --account=YOUR_ACCOUNT

set -euo pipefail
cd "${SLURM_SUBMIT_DIR}"

mkdir -p logs data

# ---- Load R (edit for your cluster) ----
# module purge
# module load R/4.3.2
# or conda activate ...

# ---- Parameters ----
export NSIM=500
export B=500
export B_INNER=100
export LEVEL=0.95
export SEED_BASE=2026

echo "Job: ${SLURM_JOB_ID}  Task: ${SLURM_ARRAY_TASK_ID}"
echo "PWD: $(pwd)"

Rscript scripts/run_scenario_main.R

