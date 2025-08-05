# Computing on Euler

This guide covers interactive sessions and batch job submission on the Euler cluster.

## Table of Contents

1. [Interactive Sessions](#interactive-sessions)
2. [Batch Jobs with SLURM](#batch-jobs-with-slurm)
3. [Job Monitoring and Management](#job-monitoring-and-management)
4. [Best Practices](#best-practices)

---

## 🖥️ Interactive Sessions

Interactive sessions on Euler allow you to work directly on compute nodes with allocated resources. This is essential for development, debugging, and testing before submitting batch jobs.

### 🚀 Requesting Interactive Sessions

The basic command to request an interactive session is:

```bash
srun --pty bash
```

This gives you a basic session with default resources. For more control, specify your requirements:

### 📊 Common Interactive Session Configurations

#### Basic CPU Session
```bash
# 2 hours, 8 CPUs, 32GB RAM
srun --time=2:00:00 --cpus-per-task=8 --mem=32G --pty bash
```

#### GPU Development Session
```bash
# 4 hours, 1 GPU, 16 CPUs, 64GB RAM, 100GB local scratch
srun --time=4:00:00 --gpus=1 --cpus-per-task=16 --mem=64G --tmp=100G --pty bash
```

#### Multi-GPU Session
```bash
# 2 hours, 4 GPUs, 32 CPUs, 128GB RAM
srun --time=2:00:00 --gpus=4 --cpus-per-task=32 --mem=128G --pty bash
```

#### High Memory Session
```bash
# 1 hour, 4 CPUs, 256GB RAM
srun --time=1:00:00 --cpus-per-task=4 --mem=256G --pty bash
```

### 🔧 Working in Interactive Sessions

Once your session starts, you'll be on a compute node:

```bash
# Check your allocated resources
echo "Hostname: $(hostname)"
echo "CPUs: $(nproc)"
echo "Memory: $(free -h | grep Mem | awk '{print $2}')"
echo "GPUs: $CUDA_VISIBLE_DEVICES"
echo "Local scratch: $TMPDIR"

# Load necessary modules
module load eth_proxy

# Activate your conda environment
conda activate myenv

# For GPU sessions, verify CUDA
nvidia-smi
```

### 📝 Interactive Development Workflow

#### 1. **Code Development with GPU**
```bash
# Request GPU session
srun --gpus=1 --mem=32G --time=2:00:00 --pty bash

# Navigate to your code
cd /cluster/home/$USER/my_project

# Run and debug
python train.py --debug
```

#### 2. **Interactive Python/IPython**
```bash
# In your interactive session
module load eth_proxy
conda activate myenv

# Start IPython with GPU support
ipython

# In IPython:
# >>> import torch
# >>> torch.cuda.is_available()
# >>> # Interactive debugging here
```

#### 3. **Container Development**
```bash
# Request session with local scratch
srun --gpus=1 --tmp=50G --mem=32G --pty bash

# Extract container to local scratch
tar -xf /cluster/work/rsl/$USER/containers/dev.tar -C $TMPDIR

# Enter container interactively
singularity shell --nv \
    --bind /cluster/project/rsl/$USER:/project \
    $TMPDIR/dev.sif

# Now you're inside the container for testing
```

### 🌐 Interactive Jupyter Sessions

ETH provides JupyterHub access to Euler:

1. **Access via browser**: https://jupyter.euler.hpc.ethz.ch
2. **Login with your nethz credentials**
3. **Select resources** (GPUs, memory, time)
4. **Your notebook runs on Euler compute nodes**

#### Launching Jupyter from Command Line
```bash
# In an interactive session
srun --gpus=1 --mem=32G --time=4:00:00 --pty bash

# Load modules
module load eth_proxy

# Start Jupyter (note the token in output)
jupyter notebook --no-browser --ip=$(hostname -i)

# From your local machine, create SSH tunnel:
# ssh -L 8888:compute-node:8888 euler
# Then open http://localhost:8888 in your browser
```

### 💻 VSCode Remote Development

You can use VSCode directly on Euler nodes:

#### Option 1: Via JupyterHub
1. Go to https://jupyter.euler.hpc.ethz.ch
2. Select "Code Server" instead of JupyterLab
3. VSCode opens in your browser with Euler resources

#### Option 2: SSH Remote Development
```bash
# First, request an interactive session
srun --gpus=1 --mem=32G --time=4:00:00 --pty bash

# Note the compute node name (e.g., eu-g1-001)
hostname

# From your local VSCode:
# 1. Install "Remote - SSH" extension
# 2. Connect to: ssh username@euler
# 3. Then SSH to the compute node from terminal
```

### ⏰ Time Limits and Best Practices

#### Time Limits
- Default: 1 hour if not specified
- Maximum interactive time: 24 hours
- GPU sessions may have shorter limits during peak usage

#### Best Practices
1. **Request only what you need** - Others are waiting for resources
2. **Use `--tmp` for I/O intensive work** - Local scratch is much faster
3. **Exit when done** - Don't leave idle sessions
4. **Save your work frequently** - Sessions can be terminated
5. **Use screen/tmux for long sessions** - Protects against disconnections

### ❗ Common Issues and Solutions

**Session won't start (pending)**
```bash
# Check queue status
squeue -u $USER

# Check available resources
sinfo -p gpu

# Try requesting fewer resources or different partition
```

**Disconnection from interactive session**
```bash
# Prevent with screen/tmux
screen -S mysession
srun --gpus=1 --pty bash

# Detach: Ctrl+A, D
# Reattach: screen -r mysession
```

**Out of memory in session**
```bash
# Monitor memory usage
watch -n 1 free -h

# Check your process memory
ps aux | grep $USER

# Request more memory next time
```

### 📋 Quick Reference Card

| Task | Command |
|------|---------|
| Basic session | `srun --pty bash` |
| GPU session | `srun --gpus=1 --pty bash` |
| Specific time | `srun --time=4:00:00 --pty bash` |
| More memory | `srun --mem=64G --pty bash` |
| Local scratch | `srun --tmp=100G --pty bash` |
| Check allocation | `scontrol show job $SLURM_JOB_ID` |
| Exit session | `exit` or `Ctrl+D` |

---

## 📝 Batch Jobs with SLURM

SLURM batch scripts allow you to submit jobs that run without manual intervention. Here are tested examples for common use cases on the Euler cluster.

### 🎯 Basic Job Script Template

```bash
#!/bin/bash
#SBATCH --job-name=my_job
#SBATCH --output=logs/job_%j.out
#SBATCH --error=logs/job_%j.err
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G

# Load required modules
module load eth_proxy

# Job info
echo "Job started on $(hostname) at $(date)"
echo "Job ID: $SLURM_JOB_ID"

# Your commands here
cd /cluster/home/$USER/my_project
python my_script.py

echo "Job completed at $(date)"
```

Submit with: `sbatch my_job.sh`

### 🎮 GPU Selection and Memory Requirements

#### Requesting Specific GPU Types

```bash
# Request any available GPU
#SBATCH --gpus=1

# Request specific GPU model
#SBATCH --gpus=nvidia_geforce_rtx_4090:1     # RTX 4090 (24GB VRAM)
#SBATCH --gpus=nvidia_geforce_rtx_3090:1     # RTX 3090 (24GB VRAM)
#SBATCH --gpus=nvidia_a100_80gb_pcie:1       # A100 (80GB VRAM)
#SBATCH --gpus=nvidia_a100-pcie-40gb:1       # A100 (40GB VRAM)
#SBATCH --gpus=tesla_v100-sxm2-32gb:1        # V100 (32GB VRAM)

# Request multiple GPUs of same type
#SBATCH --gpus=nvidia_geforce_rtx_4090:4     # 4x RTX 4090
```

#### GPU Memory vs System Memory

```bash
# System memory (RAM) - shared by CPUs
#SBATCH --mem=64G              # Total memory for job
#SBATCH --mem-per-cpu=8G       # Memory per CPU core

# GPU memory (VRAM) is fixed by GPU type:
# RTX 4090: 24GB VRAM
# RTX 3090: 24GB VRAM  
# A100: 40GB or 80GB VRAM
# V100: 32GB VRAM
# RTX 2080 Ti: 11GB VRAM
```

#### Example: Large Model Training

```bash
#!/bin/bash
#SBATCH --job-name=llm-training
#SBATCH --gpus=nvidia_a100_80gb_pcie:1  # Need 80GB VRAM for model
#SBATCH --cpus-per-task=32               # Many CPUs for data loading
#SBATCH --mem=256G                       # Large system RAM for dataset
#SBATCH --time=72:00:00
#SBATCH --tmp=500G                       # Local scratch for dataset

module load eth_proxy

# The A100 80GB GPU allows loading larger models
# System RAM (256GB) is for CPU operations and data loading
# GPU VRAM (80GB) is for model weights and activations
```

### 🚀 GPU Training Script

```bash
#!/bin/bash
#SBATCH --job-name=gpu-training
#SBATCH --output=logs/train_%j.out
#SBATCH --error=logs/train_%j.err
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=4G
#SBATCH --gpus=1                # Request any available GPU
#SBATCH --tmp=100G

# For specific GPU types, use one of these instead:
# #SBATCH --gpus=nvidia_geforce_rtx_4090:1     # RTX 4090 (24GB)
# #SBATCH --gpus=nvidia_geforce_rtx_3090:1     # RTX 3090 (24GB)  
# #SBATCH --gpus=nvidia_a100_80gb_pcie:1       # A100 80GB
# #SBATCH --gpus=nvidia_a100-pcie-40gb:1       # A100 40GB
# #SBATCH --gpus=tesla_v100-sxm2-32gb:1        # V100 32GB

# Load modules
module load eth_proxy

# Job information
echo "========================================="
echo "SLURM Job ID: $SLURM_JOB_ID"
echo "Running on: $(hostname)"
echo "Starting at: $(date)"
echo "GPU allocation: $CUDA_VISIBLE_DEVICES"
echo "========================================="

# Copy dataset to local scratch for faster I/O
echo "Copying dataset to local scratch..."
cp -r /cluster/scratch/$USER/datasets/my_dataset $TMPDIR/

# Activate conda environment
source /cluster/project/rsl/$USER/miniconda3/bin/activate
conda activate ml_env

# Run training
cd /cluster/home/$USER/my_ml_project
python train.py \
    --data-dir $TMPDIR/my_dataset \
    --output-dir /cluster/project/rsl/$USER/results/$SLURM_JOB_ID \
    --epochs 100 \
    --batch-size 64 \
    --lr 0.001

# Copy final results back
echo "Copying results..."
cp -r $TMPDIR/checkpoints/* /cluster/project/rsl/$USER/checkpoints/

echo "Job completed at $(date)"
```

### 🔥 Multi-GPU Distributed Training

```bash
#!/bin/bash
#SBATCH --job-name=distributed-training
#SBATCH --output=logs/distributed_%j.out
#SBATCH --error=logs/distributed_%j.err
#SBATCH --time=48:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=8G
#SBATCH --gpus=4
#SBATCH --tmp=200G

module load eth_proxy

echo "Multi-GPU training on $(hostname)"
echo "GPUs: $CUDA_VISIBLE_DEVICES"
echo "Number of GPUs: $(echo $CUDA_VISIBLE_DEVICES | tr ',' '\n' | wc -l)"

# Prepare data on local scratch
tar -xf /cluster/scratch/$USER/datasets/imagenet.tar -C $TMPDIR/

# Activate environment
source /cluster/project/rsl/$USER/miniconda3/bin/activate
conda activate pytorch_env

# Set distributed training environment variables
export MASTER_ADDR=$(hostname)
export MASTER_PORT=29500
export WORLD_SIZE=4

# Run distributed training
cd /cluster/home/$USER/vision_project
python -m torch.distributed.run \
    --nproc_per_node=4 \
    --master_addr=$MASTER_ADDR \
    --master_port=$MASTER_PORT \
    train_distributed.py \
    --data $TMPDIR/imagenet \
    --output /cluster/project/rsl/$USER/results/$SLURM_JOB_ID \
    --sync-bn \
    --amp

echo "Training completed at $(date)"
```

### 🔄 Array Jobs for Parallel Processing

```bash
#!/bin/bash
#SBATCH --job-name=param-sweep
#SBATCH --output=logs/array_%A_%a.out
#SBATCH --error=logs/array_%A_%a.err
#SBATCH --time=02:00:00
#SBATCH --array=1-50
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4G
#SBATCH --gpus=1

module load eth_proxy

# Array job information
echo "Array Job ID: $SLURM_ARRAY_JOB_ID"
echo "Array Task ID: $SLURM_ARRAY_TASK_ID"
echo "Running on: $(hostname)"

# Define parameter arrays
learning_rates=(0.001 0.0001 0.00001 0.01 0.1)
batch_sizes=(16 32 64 128 256)

# Calculate indices for 2D parameter grid
lr_index=$(( ($SLURM_ARRAY_TASK_ID - 1) / ${#batch_sizes[@]} ))
bs_index=$(( ($SLURM_ARRAY_TASK_ID - 1) % ${#batch_sizes[@]} ))

LR=${learning_rates[$lr_index]}
BS=${batch_sizes[$bs_index]}

echo "Testing LR=$LR, Batch Size=$BS"

# Activate environment
source /cluster/project/rsl/$USER/miniconda3/bin/activate
conda activate ml_env

# Run experiment
cd /cluster/home/$USER/hyperparameter_search
python train.py \
    --lr $LR \
    --batch-size $BS \
    --epochs 20 \
    --output /cluster/project/rsl/$USER/hp_search/lr${LR}_bs${BS} \
    --seed $SLURM_ARRAY_TASK_ID
```

Submit array job: `sbatch --array=1-25 array_job.sh`

### 📦 Container-Based Job

```bash
#!/bin/bash
#SBATCH --job-name=container-job
#SBATCH --output=logs/container_%j.out
#SBATCH --error=logs/container_%j.err
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=8G
#SBATCH --gpus=2
#SBATCH --tmp=150G

module load eth_proxy

echo "Container job started on $(hostname)"
echo "Extracting container to local scratch..."

# Extract container (much faster than running from /cluster/work)
time tar -xf /cluster/work/rsl/$USER/containers/ml_stack.tar -C $TMPDIR

# Prepare data
echo "Preparing data..."
mkdir -p $TMPDIR/data
cp -r /cluster/scratch/$USER/datasets/train_data $TMPDIR/data/

# Run training in container
echo "Starting training..."
singularity exec \
    --nv \
    --bind $TMPDIR/data:/data:ro \
    --bind /cluster/project/rsl/$USER/results/$SLURM_JOB_ID:/output \
    --bind /cluster/project/rsl/$USER/checkpoints:/checkpoints \
    $TMPDIR/ml_stack.sif \
    python /app/train.py \
        --data /data/train_data \
        --output /output \
        --checkpoint-dir /checkpoints \
        --resume-from latest

echo "Job completed at $(date)"
```

---

## 🔍 Job Monitoring and Management

### Useful SLURM Commands

```bash
# Submit job
sbatch my_job.sh

# Check job status
squeue -u $USER

# Detailed job info
scontrol show job <job_id>

# Cancel job
scancel <job_id>

# Cancel all your jobs
scancel -u $USER

# View job efficiency after completion
seff <job_id>

# Monitor job in real-time
watch -n 10 squeue -u $USER
```

### 🛠️ Debugging Failed Jobs

```bash
#!/bin/bash
#SBATCH --job-name=debug-job
#SBATCH --output=logs/debug_%j.out
#SBATCH --error=logs/debug_%j.err
#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4G
#SBATCH --gpus=1

# Enable bash debugging
set -e  # Exit on error
set -u  # Exit on undefined variable
set -x  # Print commands as they execute

module load eth_proxy

# Print environment for debugging
echo "=== Environment ==="
env | grep SLURM
echo "=== GPU Info ==="
nvidia-smi
echo "=== Memory Info ==="
free -h
echo "=== Disk Space ==="
df -h $TMPDIR

# Your actual commands with error checking
if ! python --version; then
    echo "Python not found!"
    exit 1
fi

# Run with explicit error handling
python my_script.py || {
    echo "Script failed with exit code $?"
    echo "Current directory: $(pwd)"
    echo "Files present: $(ls -la)"
    exit 1
}
```

---

## 💡 Best Practices

### Best Practices for Job Scripts

1. **Always specify time limits** - Jobs without time limits may be deprioritized
2. **Create log directories** - `mkdir -p logs` before submitting
3. **Use local scratch ($TMPDIR)** - Much faster than network storage
4. **Request appropriate resources** - Don't over-request, it delays your job
5. **Use job arrays** - For embarrassingly parallel tasks
6. **Add error handling** - Check exit codes and add recovery logic

### 📝 Job Script Checklist

Before submitting your job, verify:

- [ ] Shebang line: `#!/bin/bash`
- [ ] Job name is descriptive
- [ ] Output/error paths exist (`mkdir -p logs`)
- [ ] Time limit is appropriate
- [ ] Memory request is reasonable
- [ ] GPU request matches your code
- [ ] Module `eth_proxy` is loaded
- [ ] Paths use `$USER` variable
- [ ] Local scratch `$TMPDIR` used for I/O
- [ ] Results saved to persistent storage

---

## 🧪 Test Scripts

We provide test scripts for all computing scenarios:

### Interactive Sessions
- Test scripts are provided inline in the examples above

### Batch Jobs
- **[test_cpu_job.sh](scripts/tests/computing-guide/test_cpu_job.sh)** - Basic CPU job submission
- **[test_basic_cpu.sh](scripts/tests/computing-guide/test_basic_cpu.sh)** - Alternative CPU test
- **[test_gpu_job.sh](scripts/tests/computing-guide/test_gpu_job.sh)** - GPU allocation test
- **[test_gpu_specific.sh](scripts/tests/computing-guide/test_gpu_specific.sh)** - Specific GPU type selection (RTX 4090)
- **[test_array_job.sh](scripts/tests/computing-guide/test_array_job.sh)** - Array job for parameter sweeps

To run the tests:
```bash
# Test basic job submission
sbatch test_cpu_job.sh

# Test GPU allocation
sbatch test_gpu_job.sh

# Test specific GPU request
sbatch test_gpu_specific.sh

# Test array jobs (creates 6 tasks)
sbatch test_array_job.sh
```