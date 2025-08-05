#!/bin/bash
#SBATCH --job-name=test-gpu-4090
#SBATCH --output=test_gpu_4090_%j.out
#SBATCH --error=test_gpu_4090_%j.err
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2G
#SBATCH --gpus=nvidia_geforce_rtx_4090:1

# Load required modules
module load eth_proxy

echo "Specific GPU Job Test (RTX 4090)"
echo "================================"
echo "Job started on $(hostname) at $(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "Requested GPU: RTX 4090"
echo "GPU allocation: $CUDA_VISIBLE_DEVICES"
echo ""

# Show GPU information
echo "GPU Information:"
echo "================"
nvidia-smi
echo ""

echo "Job completed at $(date)"