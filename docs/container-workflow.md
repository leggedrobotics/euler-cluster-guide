# Container Workflow

This page provides a detailed, tested workflow for deploying containerized applications on the Euler cluster.

## Overview

The workflow consists of four main steps:
1. **Build** a Docker container locally
2. **Convert** to Singularity format
3. **Transfer** to the cluster
4. **Run** using SLURM

## Step 1: Building Docker Containers

### Basic Dockerfile Template

```dockerfile
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --no-cache-dir \
    torch==2.0.1 --index-url https://download.pytorch.org/whl/cu118 \
    numpy \
    scipy \
    matplotlib

# Set working directory
WORKDIR /workspace

# Copy application code
COPY . .

# Set entrypoint
ENTRYPOINT ["python3"]
```

### Building the Image

```bash
# Build the image
docker build -t my-app:latest .

# Test locally (optional)
docker run --rm -it my-app:latest --version
```

### Multi-Stage Builds (Recommended for smaller images)

```dockerfile
# Build stage
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 AS builder
RUN apt-get update && apt-get install -y build-essential
# ... compile dependencies ...

# Runtime stage
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
COPY --from=builder /compiled/libs /usr/local/lib
# ... rest of the Dockerfile ...
```

## Step 2: Converting to Singularity

### Prerequisites

Ensure Apptainer is installed:
```bash
apptainer --version  # Should show 1.2.5 or compatible
```

### Conversion Process

```bash
# Create directory for exports
mkdir -p container-exports
cd container-exports

# Convert Docker to Singularity sandbox
APPTAINER_NOHTTPS=1 apptainer build --sandbox --fakeroot \
    my-app.sif docker-daemon://my-app:latest

# Compress for transfer (required for efficient copying)
tar -czf my-app.tar.gz my-app.sif
```

**Timing**: For an 8GB container, expect:
- Conversion: 1-2 minutes
- Compression: 2-3 minutes

## Step 3: Transferring to Euler

### Directory Structure

First, set up your directories on Euler:
```bash
ssh euler << 'EOF'
mkdir -p /cluster/work/rsl/$USER/containers
mkdir -p /cluster/project/rsl/$USER/results
mkdir -p /cluster/scratch/$USER/datasets
EOF
```

### Transfer the Container

```bash
# Transfer compressed container
scp container-exports/my-app.tar.gz \
    euler:/cluster/work/rsl/$USER/containers/

# For large transfers, use rsync with resume capability
rsync -avP container-exports/my-app.tar.gz \
    euler:/cluster/work/rsl/$USER/containers/
```

## Step 4: Running with SLURM

### Basic Job Script

Create `job_script.sh`:

```bash
#!/bin/bash
#SBATCH --job-name=my-container-job
#SBATCH --output=logs/job_%j.out
#SBATCH --error=logs/job_%j.err
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --gpus=1
#SBATCH --tmp=100G

# Load modules
module load eth_proxy

# Job info
echo "Job started on $(hostname) at $(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "GPU: $CUDA_VISIBLE_DEVICES"

# Extract container to local scratch (CRITICAL for performance)
echo "Extracting container..."
time tar -xzf /cluster/work/rsl/$USER/containers/my-app.tar.gz -C $TMPDIR

# Setup directories
RESULTS_DIR="/cluster/project/rsl/$USER/results/$SLURM_JOB_ID"
mkdir -p $RESULTS_DIR

# Run container
echo "Running application..."
time singularity exec \
    --nv \
    --bind $RESULTS_DIR:/output \
    --bind /cluster/scratch/$USER:/data:ro \
    $TMPDIR/my-app.sif \
    python3 /workspace/main.py \
        --data-dir /data \
        --output-dir /output

echo "Job completed at $(date)"
```

### Multi-GPU Job Script

For parallel GPU training:

```bash
#!/bin/bash
#SBATCH --job-name=multi-gpu-training
#SBATCH --output=logs/job_%j.out
#SBATCH --error=logs/job_%j.err
#SBATCH --time=72:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=8G
#SBATCH --gpus=4
#SBATCH --tmp=200G

module load eth_proxy

# Extract container
tar -xzf /cluster/work/rsl/$USER/containers/my-app.tar.gz -C $TMPDIR

# Run distributed training
singularity exec \
    --nv \
    --bind /cluster/project/rsl/$USER/checkpoints:/checkpoints \
    --bind /cluster/scratch/$USER/datasets:/data:ro \
    $TMPDIR/my-app.sif \
    python3 -m torch.distributed.run \
        --nproc_per_node=4 \
        train.py --distributed
```

### Interactive Development

For debugging and development:

```bash
# Request interactive session
srun --gpus=1 --mem=32G --tmp=50G --pty bash

# Extract and run container interactively
tar -xzf /cluster/work/rsl/$USER/containers/my-app.tar.gz -C $TMPDIR
singularity shell --nv $TMPDIR/my-app.sif
```

## Performance Optimization

### Storage Best Practices

| Data Type | Location | Purpose |
|-----------|----------|---------|
| Containers | `/cluster/work/rsl/$USER/containers/` | Long-term storage |
| Results | `/cluster/project/rsl/$USER/results/` | Persistent outputs |
| Datasets | `/cluster/scratch/$USER/` | Large data, auto-cleaned |
| Working files | `$TMPDIR` | Fast local scratch |

### Timing Benchmarks

From our testing with 8GB containers:

```
Container extraction to $TMPDIR: 10-15 seconds
Container extraction to /cluster/work: 2-5 minutes (avoid!)
Container startup overhead: ~2 seconds
GPU initialization: <1 second
```

### Tips for Optimal Performance

1. **Always extract to `$TMPDIR`**
   ```bash
   # Good - fast local storage
   tar -xzf /cluster/work/.../container.tar.gz -C $TMPDIR
   
   # Bad - slow network storage
   tar -xzf container.tar.gz -C /cluster/work/...
   ```

2. **Pre-stage data when possible**
   ```bash
   # Copy frequently accessed data to $TMPDIR
   cp -r /cluster/scratch/$USER/dataset $TMPDIR/
   ```

3. **Use read-only binds for input data**
   ```bash
   --bind /cluster/scratch/$USER/data:/data:ro
   ```

4. **Monitor resource usage**
   ```bash
   # In another terminal while job runs
   ssh euler squeue -j $JOBID
   ssh $NODE nvidia-smi
   ```

## Troubleshooting

### Common Issues and Solutions

**Container extraction is very slow**
- Ensure you're extracting to `$TMPDIR`
- Check available space: `df -h $TMPDIR`
- Consider using uncompressed tar: `tar -cf` instead of `tar -czf`

**GPU not detected in container**
```bash
# Check if --nv flag is present
# Verify CUDA versions match
singularity exec --nv container.sif nvidia-smi
```

**Permission denied errors**
```bash
# Build with fakeroot
apptainer build --fakeroot ...

# Ensure directories exist and are writable
mkdir -p /cluster/project/rsl/$USER/results
```

**Out of memory during extraction**
```bash
#SBATCH --tmp=200G  # Increase local scratch
```

### Debug Commands

```bash
# Check job details
scontrol show job $SLURM_JOB_ID

# Monitor job resource usage
sstat -j $SLURM_JOB_ID

# View node status
sinfo -N -l

# Check your disk quotas
lquota
```

## Advanced Topics

### Container Caching

For frequently used containers, consider keeping extracted versions:

```bash
# One-time extraction
tar -xzf container.tar.gz -C /cluster/work/rsl/$USER/containers/extracted/

# In job script, just copy
cp -r /cluster/work/rsl/$USER/containers/extracted/my-app.sif $TMPDIR/
```

### Automated Workflows

Example automation script:

```bash
#!/bin/bash
# build_and_deploy.sh

IMAGE_NAME="my-app"
VERSION=$(date +%Y%m%d-%H%M%S)

# Build
docker build -t ${IMAGE_NAME}:${VERSION} .

# Convert
apptainer build --fakeroot ${IMAGE_NAME}-${VERSION}.sif \
    docker-daemon://${IMAGE_NAME}:${VERSION}

# Compress and transfer
tar -czf ${IMAGE_NAME}-${VERSION}.tar.gz ${IMAGE_NAME}-${VERSION}.sif
scp ${IMAGE_NAME}-${VERSION}.tar.gz euler:/cluster/work/rsl/$USER/containers/

# Create job script from template
sed "s/VERSION/${VERSION}/g" job_template.sh > job_${VERSION}.sh

# Submit
ssh euler "cd /cluster/work/rsl/$USER && sbatch job_${VERSION}.sh"
```

---

[Back to Home](/) | [View Scripts](/scripts) | [Troubleshooting](/troubleshooting)