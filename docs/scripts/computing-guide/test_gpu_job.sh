#!/bin/bash
#SBATCH --job-name=test-gpu-job
#SBATCH --output=test_gpu_%j.out
#SBATCH --error=test_gpu_%j.err
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2G
#SBATCH --gpus=1

# Load required modules
module load eth_proxy

echo "GPU Job Test"
echo "============"
echo "Job started on $(hostname) at $(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "GPU allocation: $CUDA_VISIBLE_DEVICES"
echo ""

# Show GPU information
echo "GPU Information:"
echo "================"
nvidia-smi
echo ""

# Test with specific GPU type
echo "Testing Python GPU access:"
python3 -c "import torch; print(f'PyTorch available: {torch.cuda.is_available()}'); print(f'GPU count: {torch.cuda.device_count()}'); print(f'GPU name: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"N/A\"}')" 2>/dev/null || echo "PyTorch not available in base environment"

echo ""
echo "Job completed at $(date)"