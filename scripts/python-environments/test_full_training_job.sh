#!/bin/bash
#SBATCH --job-name=test-ml-training
#SBATCH --output=test_training_%j.out
#SBATCH --error=test_training_%j.err
#SBATCH --time=00:15:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
#SBATCH --gpus=1
#SBATCH --tmp=50G

# Load modules
module load eth_proxy

echo "========================================="
echo "ML Training Job Test"
echo "========================================="
echo "Job ID: $SLURM_JOB_ID"
echo "Running on: $(hostname)"
echo "Start time: $(date)"
echo "GPU allocation: $CUDA_VISIBLE_DEVICES"
echo "CPUs: $SLURM_CPUS_PER_TASK"
echo "Temp directory: $TMPDIR"
echo "========================================="

# Show GPU info
echo -e "\nGPU Information:"
nvidia-smi --query-gpu=name,memory.total --format=csv

# Create fake dataset in local scratch
echo -e "\nPreparing fake dataset..."
mkdir -p $TMPDIR/fake_dataset/{train,val}
echo "Dataset created in $TMPDIR/fake_dataset"

# Activate conda environment
echo -e "\nActivating conda environment..."
source /cluster/project/rsl/$USER/miniconda3/bin/activate
conda activate test_env || echo "test_env not found, using base environment"

# Copy training script
echo -e "\nCopying training script..."
cp /cluster/home/$USER/fake_train.py $TMPDIR/

# Set up output directory
OUTPUT_DIR=/cluster/project/rsl/$USER/results/test_$SLURM_JOB_ID
mkdir -p $OUTPUT_DIR

# Run training
echo -e "\nStarting training..."
cd $TMPDIR
python fake_train.py \
    --data-dir $TMPDIR/fake_dataset \
    --output-dir $OUTPUT_DIR \
    --epochs 10 \
    --batch-size 64 \
    --lr 0.001

# Check results
echo -e "\nTraining completed. Results:"
if [ -f "$OUTPUT_DIR/training_results.json" ]; then
    cat $OUTPUT_DIR/training_results.json
else
    echo "No results file found"
fi

echo -e "\nOutput files:"
ls -la $OUTPUT_DIR/

# Simulate copying important results back
if [ -d "$OUTPUT_DIR/checkpoints" ]; then
    echo -e "\nCheckpoints saved:"
    ls -la $OUTPUT_DIR/checkpoints/
fi

echo -e "\n========================================="
echo "Job completed at $(date)"
echo "Results saved to: $OUTPUT_DIR"
echo "========================================="