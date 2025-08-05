
---
layout: default
title: Complete Guide
nav_order: 5
has_children: false
permalink: /complete-guide/
---

# Complete Euler Cluster Guide
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

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

## 6. Interactive Sessions

## 7. Sample Sbatch Scripts

## 8. Sample Training Workflow (Conda)

## 9. Sample Container Workflow

This section provides a complete, tested workflow for building Docker containers, converting them to Singularity format, and running them on the Euler cluster using SLURM.

### Tested Configuration

This workflow has been tested and verified with:
- **Docker**: version 24.0.7
- **Apptainer**: version 1.2.5
- **Cluster**: Euler (ETH Zurich)
- **GPU**: NVIDIA GeForce RTX 2080 Ti

### 9.1 Building a Docker Container

#### Create a Dockerfile

Create a `Dockerfile` for your application. Here's a tested example for a PyTorch-based GPU computing environment:

```dockerfile
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Install Python and pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install PyTorch with CUDA support
RUN pip3 install --no-cache-dir torch==2.0.1 --index-url https://download.pytorch.org/whl/cu118

# Set working directory
WORKDIR /workspace

# Copy your application
COPY your_script.py .

# Set entrypoint
ENTRYPOINT ["python3"]
```

#### Build the Docker Image

```bash
# Build the image
docker build -t my-gpu-app:latest .

# Test locally (if you have Docker with GPU support)
docker run --rm -it --gpus all my-gpu-app:latest your_script.py
```

### 9.2 Converting to Singularity Format

Convert your Docker image to Singularity format on your local machine:

```bash
# Create exports directory
mkdir -p exports

# Convert Docker to Singularity sandbox (using fakeroot for non-root conversion)
cd exports
APPTAINER_NOHTTPS=1 apptainer build --sandbox --fakeroot my-gpu-app.sif docker-daemon://my-gpu-app:latest

# Compress to tar for efficient transfer
tar -cvf my-gpu-app.tar my-gpu-app.sif
```

**Timing Note**: For an 8GB container, the conversion process takes approximately 1-2 minutes.

### 9.3 Transferring to Euler

Transfer the Singularity image to your work directory on Euler:

```bash
# Create directories on cluster
ssh <username>@euler.ethz.ch "mkdir -p /cluster/work/rsl/$USER/containers"
ssh <username>@euler.ethz.ch "mkdir -p /cluster/project/rsl/$USER/results"

# Transfer the tar file (8GB takes ~2-5 minutes depending on connection)
scp exports/my-gpu-app.tar <username>@euler.ethz.ch:/cluster/work/rsl/$USER/containers/
```

### 9.4 SLURM Job Script

Create an optimized job script `gpu_job.sh`:

```bash
#!/bin/bash
#SBATCH --job-name=gpu-container
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --gpus=1
#SBATCH --tmp=100G  # Request local scratch space

# Load required modules
module load eth_proxy

echo "Starting job on $(hostname)"
echo "Job ID: $SLURM_JOB_ID"
echo "Allocated GPU: $CUDA_VISIBLE_DEVICES"
echo "Start time: $(date)"

# Extract container in local scratch (much faster than network storage)
echo "Extracting container to $TMPDIR..."
time tar -xf /cluster/work/rsl/$USER/containers/my-gpu-app.tar -C $TMPDIR

# Create output directory in project partition
mkdir -p /cluster/project/rsl/$USER/results/$SLURM_JOB_ID

# Run the container
echo "Running container..."
time singularity exec \
    --nv \
    --bind /cluster/project/rsl/$USER/results/$SLURM_JOB_ID:/output:rw \
    --bind /cluster/scratch/$USER:/scratch:rw \
    $TMPDIR/my-gpu-app.sif \
    your_script.py --output-dir /output

echo "Job completed at $(date)"
echo "Results saved to: /cluster/project/rsl/$USER/results/$SLURM_JOB_ID"
```

### 9.5 Submitting and Monitoring Jobs

```bash
# Submit the job
sbatch gpu_job.sh

# Check job status
squeue -u $USER

# Monitor job output in real-time
tail -f job_<job_id>.out

# Check GPU utilization (once job is running)
ssh <node_name> nvidia-smi
```

### 9.6 Performance Benchmarks

Based on our testing with an 8GB container:
- **Container extraction time**: ~10-15 seconds (to `$TMPDIR`)
- **Container startup overhead**: ~2 seconds
- **GPU detection and initialization**: < 1 second

### 9.7 Complete Working Example

Here's a complete example that was tested on Euler:

#### test_gpu.py
```python
#!/usr/bin/env python3
import torch
import os
from datetime import datetime

print("="*50)
print("GPU Test on Euler Cluster")
print("="*50)
print(f"Hostname: {os.uname().nodename}")
print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")

if torch.cuda.is_available():
    print(f"CUDA version: {torch.version.cuda}")
    print(f"GPU count: {torch.cuda.device_count()}")
    for i in range(torch.cuda.device_count()):
        print(f"GPU {i}: {torch.cuda.get_device_name(i)}")
    
    # Test computation
    x = torch.randn(5000, 5000, device='cuda')
    y = torch.matmul(x, x)
    print(f"\nMatrix multiplication (5000x5000) completed on {y.device}")

# Save results
os.makedirs("/output", exist_ok=True)
with open("/output/results.txt", "w") as f:
    f.write(f"Test completed at {datetime.now()}\n")
    f.write(f"PyTorch: {torch.__version__}\n")
    f.write(f"CUDA available: {torch.cuda.is_available()}\n")
print("\nResults saved to /output/results.txt")
```

### 9.8 Best Practices

1. **Storage Guidelines**
   - Containers: Store in `/cluster/work/rsl/$USER/containers/`
   - Results: Save to `/cluster/project/rsl/$USER/results/`
   - Datasets: Use `/cluster/scratch/$USER/` for large data
   - Always extract containers to `$TMPDIR` for best performance

2. **Container Optimization**
   - Keep containers under 10GB when possible
   - Use multi-stage builds to minimize size
   - Include only necessary dependencies
   - Test containers locally before cluster deployment

3. **Resource Allocation**
   - Request sufficient `--tmp` space (container size + working space)
   - For 8GB containers, request at least 50-100GB tmp space
   - Use `--mem-per-cpu=4G` or more for deep learning workloads

4. **Debugging Tips**
   - Check extraction time in job error file (`job_*.err`)
   - Verify GPU allocation with `nvidia-smi`
   - Test containers interactively first: `srun --gpus=1 --pty bash`
   - Save intermediate outputs for troubleshooting

5. **Multi-GPU Jobs**
   ```bash
   #SBATCH --gpus=4  # Request 4 GPUs
   
   # In your Python script, use:
   if torch.cuda.device_count() > 1:
       model = torch.nn.DataParallel(model)
   ```

### 9.9 Troubleshooting

**Container extraction is slow**
- Ensure you're extracting to `$TMPDIR`, not network storage
- Check if tmp space is sufficient

**GPU not detected**
- Verify `--nv` flag is used with singularity
- Check CUDA versions match between container and cluster
- Ensure job requested GPUs with `--gpus=N`

**Permission denied errors**
- Use `--fakeroot` when building containers
- Ensure output directories exist and have write permissions

**Out of memory errors**
- Increase `--mem-per-cpu` allocation
- Check if `$TMPDIR` has enough space
- Monitor memory usage with `sstat -j $SLURM_JOB_ID`

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
