#!/bin/bash
#SBATCH --job-name=test-container-extract
#SBATCH --output=test_container_%j.out
#SBATCH --error=test_container_%j.err
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2G
#SBATCH --tmp=20G

# Load required modules
module load eth_proxy

echo "Container Extraction Test"
echo "========================"
echo "Job started on $(hostname) at $(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "Temp directory: $TMPDIR"
echo ""

# Check available space
echo "Available space in $TMPDIR:"
df -h $TMPDIR
echo ""

# Test extraction timing
echo "Extracting container to local scratch..."
time tar -xf /cluster/work/rsl/$USER/containers/euler-test.tar -C $TMPDIR

echo ""
echo "Extraction complete. Checking contents:"
ls -la $TMPDIR/
echo ""

# Check if it's a singularity image
if [ -f "$TMPDIR/euler-test.sif" ]; then
    echo "Found singularity image: euler-test.sif"
    echo "Image size: $(du -h $TMPDIR/euler-test.sif | cut -f1)"
    
    echo ""
    echo "Testing singularity exec:"
    singularity exec $TMPDIR/euler-test.sif echo "Hello from container!"
fi

echo ""
echo "Job completed at $(date)"