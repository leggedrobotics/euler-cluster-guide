#!/bin/bash
#SBATCH --job-name=test-cpu-job
#SBATCH --output=test_cpu_%j.out
#SBATCH --error=test_cpu_%j.err
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1G

# Load required modules
module load eth_proxy

echo "Job started on $(hostname) at $(date)"
echo "Job ID: $SLURM_JOB_ID"
echo ""
echo "System Information:"
echo "==================="
echo "CPU count: $(nproc)"
echo "Memory: $(free -h | grep Mem)"
echo "User: $USER"
echo "Working directory: $(pwd)"
echo "Temp directory: $TMPDIR"
echo ""
echo "Environment modules:"
module list 2>&1
echo ""
echo "Job completed at $(date)"