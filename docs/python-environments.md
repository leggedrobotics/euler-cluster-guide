# Python Environments and ML Training

This guide covers setting up Python environments on Euler and provides a complete machine learning training workflow.

## Table of Contents

1. [Setting Up Miniconda](#setting-up-miniconda)
2. [Managing Environments](#managing-environments)
3. [ML Training Workflow](#ml-training-workflow)
4. [Performance Tips](#performance-tips)

---

## 🐍 Setting Up Miniconda

Python virtual environments are commonly used on Euler for managing dependencies in a clean, reproducible way. One of the best tools for this purpose is [**Miniconda**](https://www.anaconda.com/docs/getting-started/miniconda/main), a lightweight version of Anaconda.

### 📦 Installing Miniconda3

To install Miniconda3, follow these steps:

```bash
# Create a directory for Miniconda
mkdir -p /cluster/project/rsl/$USER/miniconda3

# Download the installer
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /cluster/project/rsl/$USER/miniconda3/miniconda.sh

# Run the installer silently
bash /cluster/project/rsl/$USER/miniconda3/miniconda.sh -b -u -p /cluster/project/rsl/$USER/miniconda3/

# Clean up the installer
rm /cluster/project/rsl/$USER/miniconda3/miniconda.sh

# Initialize conda for bash
/cluster/project/rsl/$USER/miniconda3/bin/conda init bash

# Prevent auto-activation of the base environment
conda config --set auto_activate_base false
```

### 🚫 Avoid Installing in Home Directory

Installing Miniconda in your home directory (`~/miniconda3`) is **not recommended** due to storage and inode limits.

Instead, install it in your **project directory**:

```bash
/cluster/project/rsl/$USER/miniconda3
```

#### ✅ If you've already installed Miniconda in your home directory:

You can move it to your project directory and create a symbolic link:

```bash
mv ~/miniconda3 /cluster/project/rsl/$USER/
ln -s /cluster/project/rsl/$USER/miniconda3 ~/miniconda3
```

This way, conda commands referencing `~/miniconda3` will still work, while the files reside in a directory with more storage and inode capacity.

---

## 🧪 Managing Environments

### Creating a Sample Conda Environment

Once Miniconda is installed and configured, you can create a new conda environment like this:

```bash
conda create -n myenv python=3.10
```

To activate the environment:

```bash
conda activate myenv
```

You can install packages as needed:

```bash
conda install numpy pandas matplotlib
```

To deactivate the environment:

```bash
conda deactivate
```

### 💡 Best Practices

- Always install environments in `/cluster/project/rsl/$USER/miniconda3` to avoid inode overflow in your home directory.
- Use a compute node for the installation process, so you can make use of the bandwidth and the I/O available there, but be sure to request more than an hour for your session, so the progress is not lost if there are a lot of packages to install.
- Export the list of installed packages as soon as you confirm that an environment is working as expected. Set a mnemonic file name for that list, and save it in a secure place, in case you need to install the environment again.

---

## 🚂 ML Training Workflow

This section provides a complete end-to-end workflow for machine learning training on Euler using conda environments.

### 📋 Complete Workflow Overview

1. Set up conda environment with dependencies
2. Prepare and stage datasets
3. Develop training script with checkpointing
4. Submit batch job for training
5. Monitor progress and collect results

### 1️⃣ Environment Setup

#### Create Project Structure
```bash
ssh euler
cd /cluster/home/$USER
mkdir -p ml_project/{scripts,data,configs,logs}
cd ml_project
```

#### Install Conda Environment
```bash
# Request interactive session for installation
srun --time=1:00:00 --mem=16G --cpus-per-task=8 --pty bash

# Create environment with specific Python version
conda create -n ml_training python=3.10 -y

# Activate environment
conda activate ml_training

# Install PyTorch with CUDA support
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y

# Install additional ML packages
conda install numpy pandas scikit-learn matplotlib seaborn jupyterlab -y
pip install wandb tensorboard transformers datasets

# Save environment
conda env export > environment.yml
```

### 2️⃣ Data Preparation Script

Create `prepare_data.py`:

```python
#!/usr/bin/env python3
"""Prepare and preprocess dataset for training."""

import os
import argparse
import numpy as np
import torch
from torch.utils.data import Dataset, DataLoader
from torchvision import datasets, transforms
import h5py

def prepare_dataset(args):
    """Download and preprocess dataset."""
    
    # Define transforms
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], 
                           std=[0.229, 0.224, 0.225])
    ])
    
    # Download dataset
    print(f"Downloading dataset to {args.data_dir}")
    train_dataset = datasets.CIFAR10(
        root=args.data_dir,
        train=True,
        download=True,
        transform=transform
    )
    
    val_dataset = datasets.CIFAR10(
        root=args.data_dir,
        train=False,
        download=True,
        transform=transform
    )
    
    # Convert to HDF5 for faster loading
    if args.convert_hdf5:
        print("Converting to HDF5 format...")
        
        train_file = os.path.join(args.output_dir, 'train.h5')
        val_file = os.path.join(args.output_dir, 'val.h5')
        
        # Save training data
        with h5py.File(train_file, 'w') as f:
            images = f.create_dataset('images', (len(train_dataset), 3, 224, 224), dtype='f')
            labels = f.create_dataset('labels', (len(train_dataset),), dtype='i')
            
            for idx, (img, label) in enumerate(train_dataset):
                if idx % 1000 == 0:
                    print(f"Processing training sample {idx}/{len(train_dataset)}")
                images[idx] = img.numpy()
                labels[idx] = label
        
        print(f"Saved training data to {train_file}")
    
    return len(train_dataset), len(val_dataset)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--data-dir', type=str, required=True)
    parser.add_argument('--output-dir', type=str, required=True)
    parser.add_argument('--convert-hdf5', action='store_true')
    args = parser.parse_args()
    
    os.makedirs(args.output_dir, exist_ok=True)
    train_size, val_size = prepare_dataset(args)
    print(f"Dataset prepared: {train_size} training, {val_size} validation samples")
```

### 3️⃣ Training Script with Checkpointing

Create a comprehensive training script `train.py` that includes:
- Model initialization
- Data loading
- Training loop with validation
- Checkpointing
- Logging to wandb and tensorboard

[Full training script available in the complete example below]

### 4️⃣ Batch Job Script

Create `train_job.sh`:

```bash
#!/bin/bash
#SBATCH --job-name=ml-training
#SBATCH --output=logs/train_%j.out
#SBATCH --error=logs/train_%j.err
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=4G
#SBATCH --gpus=1
#SBATCH --tmp=100G

# Load modules
module load eth_proxy

# Job information
echo "========================================="
echo "SLURM Job ID: $SLURM_JOB_ID"
echo "Running on: $(hostname)"
echo "Starting at: $(date)"
echo "GPU: $CUDA_VISIBLE_DEVICES"
echo "========================================="

# Set up environment variables
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export WANDB_DIR=/cluster/scratch/$USER/wandb
export WANDB_CACHE_DIR=$WANDB_DIR/cache
export WANDB_CONFIG_DIR=$WANDB_DIR/config
mkdir -p $WANDB_DIR

# Activate conda environment
source /cluster/project/rsl/$USER/miniconda3/bin/activate
conda activate ml_training

# Copy dataset to local scratch for faster I/O
echo "Copying dataset to local scratch..."
cp -r /cluster/scratch/$USER/datasets/cifar10 $TMPDIR/
echo "Dataset copied successfully"

# Set paths
DATA_DIR=$TMPDIR/cifar10
OUTPUT_DIR=/cluster/project/rsl/$USER/results/$SLURM_JOB_ID
CHECKPOINT_DIR=/cluster/project/rsl/$USER/checkpoints/$SLURM_JOB_ID

mkdir -p $OUTPUT_DIR $CHECKPOINT_DIR

# Run training
cd /cluster/home/$USER/ml_project
python train.py \
    --data-dir $DATA_DIR \
    --output-dir $OUTPUT_DIR \
    --checkpoint-dir $CHECKPOINT_DIR \
    --model resnet18 \
    --epochs 100 \
    --batch-size 128 \
    --lr 0.001 \
    --num-workers 8 \
    --log-interval 50 \
    --save-interval 10

# Copy final results
echo "Copying results..."
cp -r $OUTPUT_DIR/* /cluster/project/rsl/$USER/final_results/

echo "Job completed at $(date)"
```

### 5️⃣ Monitoring and Results Collection

#### Monitor Training Progress

```bash
# Check job status
squeue -u $USER

# Watch GPU utilization
ssh euler
squeue -u $USER -o "%.18i %.9P %.8j %.8u %.2t %.10M %.6D %N"
# Get node name, then:
ssh <node_name> nvidia-smi -l 1

# View training logs in real-time
tail -f logs/train_*.out

# Check tensorboard logs
cd /cluster/project/rsl/$USER/results/<job_id>/tensorboard
tensorboard --logdir . --port 8888
# Then create SSH tunnel: ssh -L 8888:localhost:8888 euler
```

---

## 📊 Performance Tips

### 1. **Data Loading Optimization**
   - Use local scratch (`$TMPDIR`) for datasets
   - Convert to efficient formats (HDF5, TFRecord)
   - Use multiple workers for data loading

### 2. **GPU Utilization**
   - Monitor with `nvidia-smi` during training
   - Increase batch size if GPU memory allows
   - Use mixed precision training (AMP) for speedup

### 3. **Checkpointing Strategy**
   - Save checkpoints to persistent storage
   - Keep only best and recent checkpoints
   - Resume from checkpoints after job time limit

### 4. **Distributed Training**
   - Use multiple GPUs with `torch.distributed`
   - Scale batch size with number of GPUs
   - Adjust learning rate accordingly

---

## 🎯 Complete Workflow Example

```bash
# 1. Prepare environment and data
ssh euler
cd /cluster/home/$USER/ml_project
sbatch prepare_data_job.sh

# 2. Test with small run
srun --gpus=1 --mem=16G --time=0:30:00 --pty bash
python train.py --epochs 2 --batch-size 32 ...

# 3. Submit full training
sbatch train_job.sh

# 4. Monitor progress
watch -n 60 squeue -u $USER
tail -f logs/train_*.out

# 5. Analyze results
python analyze_results.py --results-dir /cluster/project/rsl/$USER/results/<job_id>
```

---

## 🧪 Test Scripts

We provide complete test scripts to verify the ML workflow:

- **[fake_train.py](scripts/tests/python-environments/fake_train.py)** - Simulated ML training script for testing
- **[test_full_training_job.sh](scripts/tests/python-environments/test_full_training_job.sh)** - Complete ML training job test

To test the full workflow:
```bash
# Copy scripts to your project
cp fake_train.py /cluster/home/$USER/
cp test_full_training_job.sh /cluster/home/$USER/

# Submit the test job
sbatch test_full_training_job.sh
```

---

## 📝 Sample Training Script

For a complete training script example with all features (checkpointing, logging, etc.), see the [Computing Guide](computing-guide.md) or download our template from the [Scripts Library](scripts.md).