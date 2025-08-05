# RSL Euler Cluster Guide

Welcome to the comprehensive guide for using the Euler HPC cluster at ETH Zurich, specifically tailored for the Robotics Systems Lab (RSL) community.

## 🚀 Quick Navigation

!!! tip "Getting Started"
    New to Euler? Start with our [Complete Guide](complete-guide/) for detailed instructions on accessing and using the cluster.

!!! example "Container Workflows" 
    Learn how to build, deploy, and run [containerized applications](container-workflow/) using Docker and Singularity on Euler.

!!! code "Scripts & Examples"
    Browse our [scripts library](scripts/) for ready-to-use SLURM job scripts, Docker examples, and automation tools.

!!! help "Troubleshooting"
    Find solutions to common issues in our [troubleshooting guide](troubleshooting/).

---

## 📋 Table of Contents

1. [Access Requirements](#access-requirements)
2. [Quick Start SSH Setup](#quick-start-ssh-setup)
3. [Storage Overview](#storage-overview)
4. [Basic SLURM Commands](#basic-slurm-commands)
5. [Container Workflow Summary](#container-workflow-summary)
6. [Interactive Sessions](#interactive-sessions)
7. [Support & Resources](#support-resources)

---

## ✅ Access Requirements

To get access to the Euler cluster:

1. **Fill out the access form**: [RSL Cluster Access Form](https://forms.gle/UsiGkXUmo9YyNHsH8)
2. **RSL members**: Directly message Manthan Patel for faster processing
3. **Access approval**: Twice weekly (Tuesdays and Fridays)

**Prerequisites:**
- Valid nethz username and password (ETH Zurich credentials)
- Terminal access (Linux/macOS or Git Bash on Windows)
- Membership in RSL group (es_hutter)

---

## 🔐 Quick Start SSH Setup

### Basic Connection
```bash
ssh <your_nethz_username>@euler.ethz.ch
```

### SSH Key Setup (Recommended)
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@ethz.ch"

# Copy to Euler
ssh-copy-id <your_nethz_username>@euler.ethz.ch

# Create SSH config (~/.ssh/config)
cat >> ~/.ssh/config << EOF
Host euler
  HostName euler.ethz.ch
  User <your_nethz_username>
  Compression yes
  ForwardX11 yes
EOF

# Now connect simply with:
ssh euler
```

### Verify Your Access
```bash
# Check group membership
my_share_info
# Should show: "You are a member of the es_hutter shareholder group"

# Create your directories
mkdir -p /cluster/project/rsl/$USER
mkdir -p /cluster/work/rsl/$USER
```

---

## 💾 Storage Overview

| Location | Quota | Files | Purpose | Persistence |
|----------|-------|-------|---------|-------------|
| **Home** `/cluster/home/$USER` | 45 GB | 450K | Code, configs | Permanent |
| **Scratch** `/cluster/scratch/$USER` | 2.5 TB | 1M | Datasets, temp files | Auto-deleted after 15 days |
| **Project** `/cluster/project/rsl/$USER` | 75 GB | 300K | Conda envs, software | Permanent |
| **Work** `/cluster/work/rsl/$USER` | 150 GB | 30K | Results, containers | Permanent |
| **Local** `$TMPDIR` | 800 GB | High | Job runtime data | Deleted after job |

### Check Your Usage
```bash
# Home and Scratch
lquota

# Project and Work
(head -n 5 && grep -w $USER) < /cluster/work/rsl/.rsl_user_data_usage.txt
(head -n 5 && grep -w $USER) < /cluster/project/rsl/.rsl_user_data_usage.txt
```

---

## 🖥️ Basic SLURM Commands

### Submit a Job
```bash
# Basic job submission
sbatch my_job.sh

# Interactive session (2 hours, 8 CPUs, 32GB RAM)
srun --time=2:00:00 --cpus-per-task=8 --mem=32G --pty bash

# GPU interactive session (4 hours, 1 GPU)
srun --time=4:00:00 --gpus=1 --mem=32G --pty bash
```

### Monitor Jobs
```bash
# Check your jobs
squeue -u $USER

# Job details
scontrol show job <job_id>

# Cancel a job
scancel <job_id>

# Job efficiency (after completion)
seff <job_id>
```

### Sample GPU Job Script
```bash
#!/bin/bash
#SBATCH --job-name=gpu-test
#SBATCH --output=logs/%j.out
#SBATCH --error=logs/%j.err
#SBATCH --time=04:00:00
#SBATCH --gpus=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --tmp=50G

module load eth_proxy

# Your GPU code here
python train.py
```

---

## 📦 Container Workflow Summary

### 1. Build Docker Image
```bash
# Create Dockerfile
cat > Dockerfile << EOF
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
RUN apt-get update && apt-get install -y python3-pip
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
COPY . /app
WORKDIR /app
CMD ["python3", "train.py"]
EOF

# Build image
docker build -t my-ml-app:latest .
```

### 2. Convert to Singularity
```bash
# Convert Docker to Singularity
apptainer build --sandbox my-ml-app.sif docker-daemon://my-ml-app:latest

# Create tar for transfer
tar -cf my-ml-app.tar my-ml-app.sif
```

### 3. Transfer to Euler
```bash
scp my-ml-app.tar euler:/cluster/work/rsl/$USER/containers/
```

### 4. Run on Euler
```bash
#!/bin/bash
#SBATCH --job-name=container-job
#SBATCH --gpus=1
#SBATCH --tmp=100G

# Extract to local scratch (fast!)
tar -xf /cluster/work/rsl/$USER/containers/my-ml-app.tar -C $TMPDIR

# Run with GPU support
singularity exec --nv $TMPDIR/my-ml-app.sif python3 /app/train.py
```

[→ Full Container Workflow Guide](container-workflow/)

---

## 🔧 Interactive Sessions

### JupyterHub Access
- **URL**: [https://jupyter.euler.hpc.ethz.ch](https://jupyter.euler.hpc.ethz.ch)
- **Login**: Use your nethz credentials
- **Features**: GPU support, VSCode option, pre-installed libraries

### Quick Interactive Commands
```bash
# Basic interactive session
srun --pty bash

# Development session with GPU
srun --gpus=1 --mem=32G --time=2:00:00 --pty bash

# High memory session
srun --mem=128G --time=1:00:00 --pty bash

# With local scratch
srun --tmp=100G --mem=32G --pty bash
```

---

## 🐍 Python Environment Setup

### Miniconda Installation
```bash
# Install in project directory (more space)
mkdir -p /cluster/project/rsl/$USER/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p /cluster/project/rsl/$USER/miniconda3
rm Miniconda3-latest-Linux-x86_64.sh

# Initialize
/cluster/project/rsl/$USER/miniconda3/bin/conda init bash
conda config --set auto_activate_base false
```

### Create Environment
```bash
conda create -n ml_env python=3.10
conda activate ml_env
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia
```

---

## 🛠️ Quick Tips

!!! success "Best Practices"
    - **Use local scratch** (`$TMPDIR`) for I/O intensive operations
    - **Request only needed resources** to reduce queue time
    - **Save work frequently** - interactive sessions can timeout
    - **Use job arrays** for parameter sweeps
    - **Load `eth_proxy` module** for internet access

!!! warning "Common Pitfalls"
    - Don't install conda in home directory (limited inodes)
    - Don't run jobs on login nodes
    - Don't exceed storage quotas
    - Remember scratch data is auto-deleted after 15 days

---

## 📞 Support & Resources

### Getting Help
- **Cluster Issues**: ETH IT ServiceDesk
- **RSL Access**: Contact Manthan Patel (patelm@ethz.ch)
- **Guide Issues**: [GitHub Issues](https://github.com/leggedrobotics/euler-cluster-guide/issues)

### Useful Links
- [Official Euler Documentation](https://scicomp.ethz.ch/wiki/Euler)
- [Getting Started with GPUs](https://scicomp.ethz.ch/wiki/Getting_started_with_GPUs)
- [JupyterHub Access](https://jupyter.euler.hpc.ethz.ch)
- [RSL Lab Homepage](https://rsl.ethz.ch)

### Tested Configuration
| Component | Version |
|-----------|---------|
| **Docker** | 24.0.7 |
| **Apptainer** | 1.2.5 |
| **Cluster** | Euler (ETH Zurich) |
| **Group** | es_hutter (RSL) |

---

*Maintained by the Robotics Systems Lab (RSL), ETH Zurich*