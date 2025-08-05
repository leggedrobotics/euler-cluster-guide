#!/bin/bash
#SBATCH --job-name=container-test-project
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4G
#SBATCH --gpus=1
#SBATCH --tmp=50G

# Load required modules
module load eth_proxy

echo "Starting container test on $(hostname)"
echo "Job ID: $SLURM_JOB_ID"
echo "Allocated GPU: $CUDA_VISIBLE_DEVICES"
echo "Start time: $(date)"

# Extract container in local scratch
echo -e "\n=== Extracting container to $TMPDIR ==="
time tar -xf /cluster/work/rsl/$USER/containers/euler-test.tar -C $TMPDIR

# Create output directory in project partition
mkdir -p /cluster/project/rsl/$USER/container-test/results/$SLURM_JOB_ID

# Run the container
echo -e "\n=== Running container ==="
time singularity exec \
    --nv \
    --bind /cluster/project/rsl/$USER/container-test/results/$SLURM_JOB_ID:/output:rw \
    $TMPDIR/euler-test.sif \
    python3 /workspace/hello_cluster.py

echo -e "\nEnd time: $(date)"
echo "Job completed!"
echo "Results saved to: /cluster/project/rsl/$USER/container-test/results/$SLURM_JOB_ID"

# Also show the container extraction timing
echo -e "\n=== Performance Summary ==="
echo "Container size: $(ls -lh /cluster/work/rsl/$USER/containers/euler-test.tar | awk '{print $5}')"
echo "Extraction location: $TMPDIR"