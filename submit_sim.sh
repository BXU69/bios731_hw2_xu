#!/bin/bash
#SBATCH --job-name=bios731_sim
#SBATCH --output=logs/sim_%A_%a.out
#SBATCH --error=logs/sim_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G                
#SBATCH --partition=work 



# Run the simulation script
Rscript scripts/run_simulation.R