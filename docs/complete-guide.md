
# Complete Euler Cluster Guide

This guide is designed to help new users access and begin working on the **Euler Cluster** at ETH Zurich, specifically for members of the **RSL group (es_hutter)**. It walks you through the complete process of connecting to the cluster, setting up secure access, and verifying your group membership.

---

## 📌 Table of Contents

1. [Access Requirements](#1-access-requirements)
2. [Connecting to Euler via SSH](#2-connecting-to-euler-via-ssh)
   - [Basic Login](#21-basic-login)
   - [Setting Up SSH Keys (Recommended)](#22-setting-up-ssh-keys-recommended)
   - [Using an SSH Config File](#23-using-an-ssh-config-file)
3. [Verifying Access to the RSL Shareholder Group](#3-verifying-access-to-the-rsl-shareholder-group)

---

## 1. ✅ Access Requirements

In order to get access to the cluster, kindly fill up the following [form](https://forms.gle/UsiGkXUmo9YyNHsH8). If you are a member of RSL, directly message Manthan Patel to add you to the cluster. The access is approved twice a week (Tuesdays and Fridays).

Before proceeding, make sure you have:

- A valid **nethz username and password** (ETH Zurich credentials)
- Access to a **terminal** (Linux/macOS or Git Bash on Windows)
- (Optional) Some familiarity with command-line tools

---

## 2. 🔐 Connecting to Euler via SSH

You’ll connect to Euler using the Secure Shell (SSH) protocol. This allows you to log into a remote machine securely from your local computer.

---

### 2.1 Basic Login

To log into the Euler cluster, open a terminal and type:

```bash
ssh <your_nethz_username>@euler.ethz.ch
```

Replace `<your_nethz_username>` with your actual ETH Zurich login.

You will be asked to enter your ETH Zurich password. If the login is successful, you'll be connected to a login node on the Euler cluster.

---

### 2.2 Setting Up SSH Keys (Recommended)

To avoid typing your password every time and to increase security, it is recommended to use SSH key-based authentication.

#### Step-by-Step Instructions:

1. **Generate an SSH key pair** on your local machine (if not already created):

   ```bash
   ssh-keygen -t ed25519 -C "<your_email>@ethz.ch"
   ```

   - Press Enter to accept the default file location (usually `~/.ssh/id_ed25519`).
   - When prompted for a passphrase, you can choose to set one or leave it empty.

2. **Copy your public key to Euler** using this command:

   ```bash
   ssh-copy-id <your_nethz_username>@euler.ethz.ch
   ```

   - You'll be asked to enter your ETH password one last time.
   - This command installs your public key in the `~/.ssh/authorized_keys` file on Euler.

Now, you should be able to log in without typing your password.

---

### 2.3 Using an SSH Config File

To make your SSH workflow easier, especially if you frequently access Euler, create or edit the `~/.ssh/config` file on your local machine.

#### Example Configuration:

```sshconfig
Host euler
  HostName euler.ethz.ch
  User <your_nethz_username>
  Compression yes
  ForwardX11 yes
  IdentityFile ~/.ssh/id_ed25519
```

- Replace `<your_nethz_username>` with your actual ETH username.
- Save and close the file.

Now, instead of typing the full SSH command, you can simply connect using:

```bash
ssh euler
```

---

## 3. 🧾 Verifying Access to the RSL Shareholder Group

Once you are logged into the Euler cluster, it's important to confirm that you have been added to the appropriate shareholder group. This ensures you can access the computing resources allocated to your research group (in this case, the RSL group).

---

### 🔍 How to Check Your Group Membership

1. While connected to Euler (after logging in via SSH), run the following command in the terminal:

   ```bash
   my_share_info
   ```

2. If everything is correctly set up, you should see output similar to the following:

   ```
   You are a member of the es_hutter shareholder group on Euler.
   ```

3. This message confirms that you are part of the `es_hutter` group, which is the shareholder group for the RSL lab.

4. Create your user directories for storage by using the following command
   ```bash 
   mkdir /cluster/project/rsl/$USER
   mkdir /cluster/work/rsl/$USER
   ```

---

### ❗ If You Do NOT See This Message:

- Double-check with your supervisor whether you've been added to the group.
- It may take a few hours after being added for the change to propagate.

---

## 4. 💾 Data Management on Euler

Effective data management is critical when working on the Euler Cluster, particularly for machine learning workflows that involve large datasets and model outputs. This section explains the available storage options and their proper usage.

---

### 📁 Home Directory (`/cluster/home/$USER`)

- **Quota**: 45 GB  
- **Inodes**: ~450,000 files  
- **Persistence**: Permanent (not purged)
- **Use Case**: Ideal for storing source code, small configuration files, scripts, and lightweight development tools.

---

### ⚡ Scratch Directory (`/cluster/scratch/$USER` or `$SCRATCH`)

- **Quota**: 2.5 TB  
- **Inodes**: 1 M  
- **Persistence**: Temporary (data is deleted if not accessed for ~15 days)
- **Use Case**: For storing datasets and temporary training outputs.
- **Recommended Dataset storage format**: Use **tar/zip/[HDF5](https://www.hdfgroup.org/solutions/hdf5/)/[WebDataset](https://github.com/webdataset/webdataset)**.


---

### 📦 Project Directory (`/cluster/project/rsl/$USER`)

- **Quota**: ≤ 75 GB  
- **Inodes**: ~300,000  
- **Use Case**: Conda environments, software packages

---

### 📂 Work Directory (`/cluster/work/rsl/$USER`)

- **Quota**: ≤ 150 GB  
- **Inodes**: ~30,000  
- **Use Case**: Saving results, large output files, tar files, singularity images. Avoid storing too many small files.

> In exceptional cases we can approve more storage space. For this, ask your supervisor to contact `patelm@ethz.ch`.

### 📂 Local Scratch Directory (`$TMPDIR`)

- **Quota**: upto 800 GB  
- **Inodes**: Very High 
- **Use Case**: Datasets and containers for a training run. 

### ❗ Quota Violations:

- You shall receive an email if you violate any of the above limits. 
- You can type `lquota` in the terminal to check your used storage space for `Home` and `Scratch` directories. 
- For usage of `Project` and `Work` directories you can run: 
   ```bash 
   (head -n 5 && grep -w $USER) < /cluster/work/rsl/.rsl_user_data_usage.txt
   (head -n 5 && grep -w $USER) < /cluster/project/rsl/.rsl_user_data_usage.txt
   ```
   Note: This wont show the per-user quota limit which is enforced by RSL ! Refer to the table below for the quota limits.

#### 🎯 FAQ: What is the difference between the `Project` and `Work` Directories and why is it necessary to make use of both?

Basically, both `Project` and `Work` are persistent storages (meaning the data is not deleted automatically); however, the use cases are different. When you have lots of small files, for example, conda environments, you should store them in the `Project` directory as it has a higher capacity for # of inodes. On the other hand, when you have larger files such as model checkpoints, singularity containers and results you should store them in the `Work` directory as the storage capacity is higher.

#### 🎯 FAQ: What is Local Scratch Directory (`$TMPDIR`) ?

Whenever you run a compute job, you can also ask for a certain amount of local scratch space (`$TMPDIR`) which allocates space on a local hard drive. The main advantage of the local scratch is, that it is located directly inside the compute nodes and not attached via the network. Thus it is highly recommended to copy over your singularity container / datasets to `$TMPDIR` and then use that for the trainings. Detailed workflows for the trainings are provided later in this guide.

---

### 📊 Summary Table of Storage Locations

| Storage Location            | Max Inodes | Max Size per User | Purged | Recommended Use Case                               |
|----------------------------|------------|----------------|--------|----------------------------------------------------|
| `/cluster/home/$USER`      | ~450,000   | 45 GB          |      No     | Code, config, small files                          |
| `/cluster/scratch/$USER`   | 1 M    | 2.5 TB             |      Yes (older than 15 days)    | Datasets, training data, temporary usage           |
| `/cluster/project/rsl/$USER`     | 300,000    | 75 GB    |      No     | Conda envs, software packages             |
| `/cluster/work/rsl/$USER`        | 30,000     | 150 GB   |      No     | Large result files, model checkpoints, Singularity containers,             |
| `$TMPDIR`        | very high     | Upto 800 GB   |      Yes (at end of job)     |     Training Datasets, Singularity Images         |

---


## 5. 🐍 Setting Up Miniconda Environments

Python virtual environments are commonly used on Euler for managing dependencies in a clean, reproducible way. One of the best tools for this purpose is [**Miniconda**](https://www.anaconda.com/docs/getting-started/miniconda/main), a lightweight version of Anaconda.

---

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

---

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

### 🧪 Creating a Sample Conda Environment

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

---

### 💡 Best Practices

- Always install environments in `/cluster/project/rsl/$USER/miniconda3` to avoid inode overflow in your home directory.
- Use a compute node for the installation process, so you can make use of the bandwidth and the I/O available there, but be sure to request more than an hour for your session, so the progress is not lost if there are a lot of packages to install.
- Export the list of installed packages as soon as you confirm that an environment is working as expected. Set a mnemonic file name for that list, and save it in a secure place, in case you need to install the environment again.
---

## 6. 🖥️ Interactive Sessions

Interactive sessions on Euler allow you to work directly on compute nodes with allocated resources. This is essential for development, debugging, and testing before submitting batch jobs.

---

### 🚀 Requesting Interactive Sessions

The basic command to request an interactive session is:

```bash
srun --pty bash
```

This gives you a basic session with default resources. For more control, specify your requirements:

---

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

---

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

---

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

---

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

---

### 💻 VSCode Remote Development

You can use VSCode directly on Euler nodes:

#### Option 1: Via JupyterHub
1. Go to https://jupyter.euler.ethz.ch
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

---

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

---

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

---

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

## 7. 📝 Sample Sbatch Scripts

SLURM batch scripts allow you to submit jobs that run without manual intervention. Here are tested examples for common use cases on the Euler cluster.

---

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

---

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

---

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

---

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

---

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

---

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

### 🔍 Job Monitoring and Management

#### Useful SLURM Commands

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

---

### 💡 Best Practices for Job Scripts

1. **Always specify time limits** - Jobs without time limits may be deprioritized
2. **Create log directories** - `mkdir -p logs` before submitting
3. **Use local scratch ($TMPDIR)** - Much faster than network storage
4. **Request appropriate resources** - Don't over-request, it delays your job
5. **Use job arrays** - For embarrassingly parallel tasks
6. **Add error handling** - Check exit codes and add recovery logic

---

### 📊 Resource Estimation Guide

| Task Type | CPUs | Memory | GPU | Time |
|-----------|------|--------|-----|------|
| Data preprocessing | 8-16 | 32-64G | 0 | 2-4h |
| CNN training (small) | 8 | 32G | 1 | 12-24h |
| Transformer training | 16-32 | 64-128G | 1-4 | 24-72h |
| Hyperparameter search | 4-8 | 16-32G | 1 | 2-4h per run |
| Batch inference | 4-8 | 16-32G | 1 | 1-2h |

---

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

## 8. 🚂 Sample Training Workflow (Conda)

This section provides a complete end-to-end workflow for machine learning training on Euler using conda environments.

---

### 📋 Complete Workflow Overview

1. Set up conda environment with dependencies
2. Prepare and stage datasets
3. Develop training script with checkpointing
4. Submit batch job for training
5. Monitor progress and collect results

---

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

---

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

---

### 3️⃣ Training Script with Checkpointing

Create `train.py`:

```python
#!/usr/bin/env python3
"""Training script with checkpointing and logging."""

import os
import sys
import time
import argparse
import json
from datetime import datetime

import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader
from torchvision import models, datasets, transforms
import wandb
from torch.utils.tensorboard import SummaryWriter

class Trainer:
    def __init__(self, args):
        self.args = args
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        
        # Initialize logging
        self.setup_logging()
        
        # Load data
        self.train_loader, self.val_loader = self.load_data()
        
        # Initialize model
        self.model = self.create_model()
        self.criterion = nn.CrossEntropyLoss()
        self.optimizer = optim.Adam(self.model.parameters(), lr=args.lr)
        self.scheduler = optim.lr_scheduler.ReduceLROnPlateau(
            self.optimizer, mode='min', patience=5
        )
        
        # Load checkpoint if resuming
        self.start_epoch = 0
        if args.resume:
            self.load_checkpoint()
    
    def setup_logging(self):
        """Initialize logging with wandb and tensorboard."""
        # Create unique run name
        run_name = f"{self.args.model}_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        
        # Initialize wandb
        if not self.args.no_wandb:
            wandb.init(
                project="euler-ml-training",
                name=run_name,
                config=vars(self.args)
            )
        
        # Initialize tensorboard
        self.writer = SummaryWriter(
            log_dir=os.path.join(self.args.output_dir, 'tensorboard', run_name)
        )
        
        # Save config
        config_path = os.path.join(self.args.output_dir, 'config.json')
        with open(config_path, 'w') as f:
            json.dump(vars(self.args), f, indent=2)
    
    def load_data(self):
        """Load training and validation data."""
        transform = transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], 
                               std=[0.229, 0.224, 0.225])
        ])
        
        train_dataset = datasets.CIFAR10(
            root=self.args.data_dir,
            train=True,
            transform=transform
        )
        
        val_dataset = datasets.CIFAR10(
            root=self.args.data_dir,
            train=False,
            transform=transform
        )
        
        train_loader = DataLoader(
            train_dataset,
            batch_size=self.args.batch_size,
            shuffle=True,
            num_workers=self.args.num_workers,
            pin_memory=True
        )
        
        val_loader = DataLoader(
            val_dataset,
            batch_size=self.args.batch_size,
            shuffle=False,
            num_workers=self.args.num_workers,
            pin_memory=True
        )
        
        return train_loader, val_loader
    
    def create_model(self):
        """Create and initialize model."""
        if self.args.model == 'resnet18':
            model = models.resnet18(pretrained=True)
            model.fc = nn.Linear(512, 10)  # CIFAR-10 has 10 classes
        elif self.args.model == 'resnet50':
            model = models.resnet50(pretrained=True)
            model.fc = nn.Linear(2048, 10)
        else:
            raise ValueError(f"Unknown model: {self.args.model}")
        
        return model.to(self.device)
    
    def train_epoch(self, epoch):
        """Train for one epoch."""
        self.model.train()
        running_loss = 0.0
        correct = 0
        total = 0
        
        start_time = time.time()
        
        for batch_idx, (inputs, labels) in enumerate(self.train_loader):
            inputs, labels = inputs.to(self.device), labels.to(self.device)
            
            # Forward pass
            self.optimizer.zero_grad()
            outputs = self.model(inputs)
            loss = self.criterion(outputs, labels)
            
            # Backward pass
            loss.backward()
            self.optimizer.step()
            
            # Statistics
            running_loss += loss.item()
            _, predicted = outputs.max(1)
            total += labels.size(0)
            correct += predicted.eq(labels).sum().item()
            
            # Log progress
            if batch_idx % self.args.log_interval == 0:
                print(f'Epoch: {epoch} [{batch_idx}/{len(self.train_loader)}] '
                      f'Loss: {loss.item():.4f} '
                      f'Acc: {100.*correct/total:.2f}%')
        
        epoch_loss = running_loss / len(self.train_loader)
        epoch_acc = 100. * correct / total
        epoch_time = time.time() - start_time
        
        return epoch_loss, epoch_acc, epoch_time
    
    def validate(self):
        """Validate the model."""
        self.model.eval()
        running_loss = 0.0
        correct = 0
        total = 0
        
        with torch.no_grad():
            for inputs, labels in self.val_loader:
                inputs, labels = inputs.to(self.device), labels.to(self.device)
                outputs = self.model(inputs)
                loss = self.criterion(outputs, labels)
                
                running_loss += loss.item()
                _, predicted = outputs.max(1)
                total += labels.size(0)
                correct += predicted.eq(labels).sum().item()
        
        val_loss = running_loss / len(self.val_loader)
        val_acc = 100. * correct / total
        
        return val_loss, val_acc
    
    def save_checkpoint(self, epoch, is_best=False):
        """Save model checkpoint."""
        checkpoint = {
            'epoch': epoch,
            'model_state_dict': self.model.state_dict(),
            'optimizer_state_dict': self.optimizer.state_dict(),
            'scheduler_state_dict': self.scheduler.state_dict(),
            'args': self.args
        }
        
        # Save latest checkpoint
        checkpoint_path = os.path.join(self.args.checkpoint_dir, 'latest.pth')
        torch.save(checkpoint, checkpoint_path)
        
        # Save best checkpoint
        if is_best:
            best_path = os.path.join(self.args.checkpoint_dir, 'best.pth')
            torch.save(checkpoint, best_path)
        
        # Save periodic checkpoint
        if epoch % self.args.save_interval == 0:
            epoch_path = os.path.join(self.args.checkpoint_dir, f'epoch_{epoch}.pth')
            torch.save(checkpoint, epoch_path)
    
    def load_checkpoint(self):
        """Load checkpoint to resume training."""
        checkpoint_path = os.path.join(self.args.checkpoint_dir, 'latest.pth')
        if os.path.exists(checkpoint_path):
            print(f"Loading checkpoint from {checkpoint_path}")
            checkpoint = torch.load(checkpoint_path, map_location=self.device)
            
            self.model.load_state_dict(checkpoint['model_state_dict'])
            self.optimizer.load_state_dict(checkpoint['optimizer_state_dict'])
            self.scheduler.load_state_dict(checkpoint['scheduler_state_dict'])
            self.start_epoch = checkpoint['epoch'] + 1
            
            print(f"Resumed from epoch {self.start_epoch}")
    
    def train(self):
        """Main training loop."""
        best_val_loss = float('inf')
        
        for epoch in range(self.start_epoch, self.args.epochs):
            print(f"\nEpoch {epoch+1}/{self.args.epochs}")
            print("-" * 50)
            
            # Training
            train_loss, train_acc, train_time = self.train_epoch(epoch)
            
            # Validation
            val_loss, val_acc = self.validate()
            
            # Learning rate scheduling
            self.scheduler.step(val_loss)
            
            # Logging
            print(f"Train Loss: {train_loss:.4f}, Train Acc: {train_acc:.2f}%")
            print(f"Val Loss: {val_loss:.4f}, Val Acc: {val_acc:.2f}%")
            print(f"Time: {train_time:.2f}s, LR: {self.optimizer.param_groups[0]['lr']:.6f}")
            
            # Log to wandb
            if not self.args.no_wandb:
                wandb.log({
                    'epoch': epoch,
                    'train_loss': train_loss,
                    'train_acc': train_acc,
                    'val_loss': val_loss,
                    'val_acc': val_acc,
                    'lr': self.optimizer.param_groups[0]['lr'],
                    'epoch_time': train_time
                })
            
            # Log to tensorboard
            self.writer.add_scalar('Loss/train', train_loss, epoch)
            self.writer.add_scalar('Loss/val', val_loss, epoch)
            self.writer.add_scalar('Accuracy/train', train_acc, epoch)
            self.writer.add_scalar('Accuracy/val', val_acc, epoch)
            
            # Save checkpoint
            is_best = val_loss < best_val_loss
            if is_best:
                best_val_loss = val_loss
            
            self.save_checkpoint(epoch, is_best)
        
        print("\nTraining completed!")
        self.writer.close()

def main():
    parser = argparse.ArgumentParser(description='ML Training on Euler')
    
    # Data arguments
    parser.add_argument('--data-dir', type=str, required=True,
                        help='Path to dataset')
    parser.add_argument('--output-dir', type=str, required=True,
                        help='Path to save outputs')
    parser.add_argument('--checkpoint-dir', type=str, required=True,
                        help='Path to save checkpoints')
    
    # Model arguments
    parser.add_argument('--model', type=str, default='resnet18',
                        choices=['resnet18', 'resnet50'],
                        help='Model architecture')
    
    # Training arguments
    parser.add_argument('--epochs', type=int, default=100,
                        help='Number of epochs')
    parser.add_argument('--batch-size', type=int, default=64,
                        help='Batch size')
    parser.add_argument('--lr', type=float, default=0.001,
                        help='Learning rate')
    parser.add_argument('--num-workers', type=int, default=4,
                        help='Number of data loading workers')
    
    # Logging arguments
    parser.add_argument('--log-interval', type=int, default=10,
                        help='Log every N batches')
    parser.add_argument('--save-interval', type=int, default=10,
                        help='Save checkpoint every N epochs')
    parser.add_argument('--no-wandb', action='store_true',
                        help='Disable wandb logging')
    
    # Resume training
    parser.add_argument('--resume', action='store_true',
                        help='Resume from latest checkpoint')
    
    args = parser.parse_args()
    
    # Create directories
    os.makedirs(args.output_dir, exist_ok=True)
    os.makedirs(args.checkpoint_dir, exist_ok=True)
    
    # Initialize trainer and start training
    trainer = Trainer(args)
    trainer.train()

if __name__ == "__main__":
    main()
```

---

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

---

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

#### Analyze Results

Create `analyze_results.py`:

```python
#!/usr/bin/env python3
"""Analyze training results and generate plots."""

import os
import json
import glob
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from tensorboard.backend.event_processing.event_accumulator import EventAccumulator

def load_tensorboard_data(log_dir):
    """Load data from tensorboard logs."""
    event_acc = EventAccumulator(log_dir)
    event_acc.Reload()
    
    data = {}
    for tag in event_acc.Tags()['scalars']:
        events = event_acc.Scalars(tag)
        data[tag] = pd.DataFrame([(e.step, e.value) for e in events],
                                 columns=['step', tag])
    
    return data

def plot_training_curves(results_dir):
    """Generate training curves."""
    # Find tensorboard directory
    tb_dirs = glob.glob(os.path.join(results_dir, 'tensorboard', '*'))
    if not tb_dirs:
        print("No tensorboard logs found")
        return
    
    tb_dir = tb_dirs[0]
    data = load_tensorboard_data(tb_dir)
    
    # Create figure
    fig, axes = plt.subplots(2, 2, figsize=(12, 10))
    
    # Plot losses
    if 'Loss/train' in data:
        axes[0, 0].plot(data['Loss/train']['step'], 
                       data['Loss/train']['Loss/train'], 
                       label='Train')
    if 'Loss/val' in data:
        axes[0, 0].plot(data['Loss/val']['step'], 
                       data['Loss/val']['Loss/val'], 
                       label='Validation')
    axes[0, 0].set_xlabel('Epoch')
    axes[0, 0].set_ylabel('Loss')
    axes[0, 0].set_title('Training and Validation Loss')
    axes[0, 0].legend()
    
    # Plot accuracies
    if 'Accuracy/train' in data:
        axes[0, 1].plot(data['Accuracy/train']['step'], 
                       data['Accuracy/train']['Accuracy/train'], 
                       label='Train')
    if 'Accuracy/val' in data:
        axes[0, 1].plot(data['Accuracy/val']['step'], 
                       data['Accuracy/val']['Accuracy/val'], 
                       label='Validation')
    axes[0, 1].set_xlabel('Epoch')
    axes[0, 1].set_ylabel('Accuracy (%)')
    axes[0, 1].set_title('Training and Validation Accuracy')
    axes[0, 1].legend()
    
    # Save figure
    plt.tight_layout()
    output_path = os.path.join(results_dir, 'training_curves.png')
    plt.savefig(output_path, dpi=300)
    print(f"Saved training curves to {output_path}")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--results-dir', type=str, required=True)
    args = parser.parse_args()
    
    plot_training_curves(args.results_dir)
```

---

### 📊 Performance Tips

1. **Data Loading Optimization**
   - Use local scratch (`$TMPDIR`) for datasets
   - Convert to efficient formats (HDF5, TFRecord)
   - Use multiple workers for data loading

2. **GPU Utilization**
   - Monitor with `nvidia-smi` during training
   - Increase batch size if GPU memory allows
   - Use mixed precision training (AMP) for speedup

3. **Checkpointing Strategy**
   - Save checkpoints to persistent storage
   - Keep only best and recent checkpoints
   - Resume from checkpoints after job time limit

4. **Distributed Training**
   - Use multiple GPUs with `torch.distributed`
   - Scale batch size with number of GPUs
   - Adjust learning rate accordingly

---

### 🎯 Complete Workflow Example

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

## 9. Sample Container Workflow

For containerized applications (Docker/Singularity), we provide a comprehensive guide with tested workflows, scripts, and troubleshooting tips.

📦 **[View the Complete Container Workflow Guide →](../container-workflow/)**

This dedicated guide covers:

- Building and optimizing Docker containers for HPC
- Converting Docker images to Singularity format
- Transferring containers to Euler efficiently
- Writing SLURM job scripts for containerized applications
- Performance benchmarks and best practices
- Complete working examples with GPU support
- Troubleshooting common container issues

The container workflow has been tested with Docker 24.0.7 and Apptainer 1.2.5 on Euler's GPU nodes.


## 10. 🔗Useful Links

Here are some essential resources to help you navigate the Euler cluster and related tools:

- 📘 [Getting Started with Clusters](https://scicomp.ethz.ch/wiki/Getting_started_with_clusters)  
  A step-by-step introduction to using HPC clusters at ETH Zurich.

- 🖥️ [Getting Started with GPUs](https://scicomp.ethz.ch/wiki/Getting_started_with_GPUs)  
  Learn how to use GPUs on Euler, including job submission and specifying GPU requirements

- 🧠 [VSCode (via JupyterHub / Code-server)](https://scicomp.ethz.ch/wiki/JupyterHub#Code-server)  
  Run VSCode in the browser directly on Euler with JupyterHub integration.

- 💾 [Storage Systems](https://scicomp.ethz.ch/wiki/Storage_systems)  
  Understand the different types of storage on Euler and how to use them effectively.

- ❓ [FAQs](https://scicomp.ethz.ch/wiki/FAQ)  
  Frequently asked questions and solutions related to Euler and scientific computing.

- 🤖 [IsaacLab Workflow](https://isaac-sim.github.io/IsaacLab/main/source/deployment/index.html)  
  Deployment instructions and best practices for using IsaacLab on HPC systems.
