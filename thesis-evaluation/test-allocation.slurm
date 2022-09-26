#!/bin/bash

#SBATCH --nodes=1
# Make all cores available to our task
#SBATCH --cpus-per-task=64
#SBATCH --partition=parcio
#SBATCH --nodelist=ant11

#SBATCH --error=/home/urz/kduwe/debug/slurm-test-%j.err --output=/home/urz/kduwe/debug/slurm-test-%j.out

srun hostname
srun nproc