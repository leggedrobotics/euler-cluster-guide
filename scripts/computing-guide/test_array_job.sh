#!/bin/bash
#SBATCH --job-name=test-array
#SBATCH --output=logs/array_%A_%a.out
#SBATCH --error=logs/array_%A_%a.err
#SBATCH --time=00:10:00
#SBATCH --array=1-6
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1G

module load eth_proxy

echo "Array Job Test"
echo "=============="
echo "Array Job ID: $SLURM_ARRAY_JOB_ID"
echo "Array Task ID: $SLURM_ARRAY_TASK_ID"
echo "Running on: $(hostname)"
echo ""

# Define parameter arrays for hyperparameter search
learning_rates=(0.001 0.01 0.1)
batch_sizes=(16 32)

# Calculate indices for 2D parameter grid
# We have 3 LRs x 2 batch sizes = 6 total combinations
lr_index=$(( ($SLURM_ARRAY_TASK_ID - 1) / ${#batch_sizes[@]} ))
bs_index=$(( ($SLURM_ARRAY_TASK_ID - 1) % ${#batch_sizes[@]} ))

LR=${learning_rates[$lr_index]}
BS=${batch_sizes[$bs_index]}

echo "Testing parameters:"
echo "Learning Rate: $LR"
echo "Batch Size: $BS"
echo ""

# Activate environment
source /cluster/project/rsl/$USER/miniconda3/bin/activate test_env 2>/dev/null || echo "Using base environment"

# Create output directory for this parameter combination
OUTPUT_DIR=/cluster/project/rsl/$USER/hp_search/lr${LR}_bs${BS}
mkdir -p $OUTPUT_DIR

# Run fake training with these parameters
if [ -f /cluster/home/$USER/fake_train.py ]; then
    python /cluster/home/$USER/fake_train.py \
        --data-dir /tmp/fake_data \
        --output-dir $OUTPUT_DIR \
        --epochs 5 \
        --batch-size $BS \
        --lr $LR \
        --seed $SLURM_ARRAY_TASK_ID
    
    echo ""
    echo "Results saved to: $OUTPUT_DIR"
else
    echo "Training script not found, simulating results..."
    echo "{\"lr\": $LR, \"bs\": $BS, \"final_loss\": $(echo "scale=4; 1.5 - $SLURM_ARRAY_TASK_ID * 0.1" | bc)}" > $OUTPUT_DIR/results.json
fi

echo ""
echo "Task $SLURM_ARRAY_TASK_ID completed"