# Scripts Library

Ready-to-use scripts for the Euler cluster, organized by workflow section. All scripts have been tested on the Euler cluster with the RSL group allocation.

## 📁 Scripts Organization

```
scripts/
├── getting-started/       # Initial setup scripts
├── data-management/       # Storage and quota management
├── python-environments/   # ML training examples
├── computing-guide/       # Job submission templates
└── container-workflow/    # Container deployment scripts
```

## 🚀 Getting Started Scripts

### Setup Verification
**[test_group_membership.sh](scripts/getting-started/test_group_membership.sh)**

Verifies RSL group membership and creates all necessary directories:
```bash
wget https://raw.githubusercontent.com/leggedrobotics/euler-cluster-guide/main/docs/scripts/getting-started/test_group_membership.sh
bash test_group_membership.sh
```

## 💾 Data Management Scripts

### Storage Quota Check
**[test_storage_quotas.sh](scripts/data-management/test_storage_quotas.sh)**

Comprehensive storage verification script that:
- Checks all storage paths and creates missing directories
- Displays current usage and quotas
- Tests `$TMPDIR` functionality in job context

## 🐍 Python & ML Training Scripts

### ML Training Example
**[fake_train.py](scripts/python-environments/fake_train.py)** | **[test_full_training_job.sh](scripts/python-environments/test_full_training_job.sh)**

Complete ML training workflow example including:
- Simulated training with checkpointing
- Progress tracking and logging
- Resource monitoring
- Proper use of local scratch for data

## 💻 Computing Scripts

### Basic Job Templates

- **[test_cpu_job.sh](scripts/computing-guide/test_cpu_job.sh)** - Basic CPU job submission
- **[test_gpu_job.sh](scripts/computing-guide/test_gpu_job.sh)** - GPU allocation test
- **[test_gpu_specific.sh](scripts/computing-guide/test_gpu_specific.sh)** - Request specific GPU type (RTX 4090)
- **[test_array_job.sh](scripts/computing-guide/test_array_job.sh)** - Array job for parameter sweeps

### Advanced Templates

#### Multi-GPU Training
```bash
#!/bin/bash
#SBATCH --job-name=multi-gpu-train
#SBATCH --output=logs/job_%j.out
#SBATCH --error=logs/job_%j.err
#SBATCH --time=72:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=8G
#SBATCH --gpus=4
#SBATCH --tmp=200G

module load eth_proxy

# Extract container to local scratch
tar -xf /cluster/work/rsl/$USER/containers/training.tar -C $TMPDIR

# Run distributed training
singularity exec \
    --nv \
    --bind /cluster/project/rsl/$USER/checkpoints:/checkpoints \
    --bind /cluster/scratch/$USER/datasets:/data:ro \
    $TMPDIR/training.sif \
    python3 -m torch.distributed.run \
        --nproc_per_node=4 \
        train.py --distributed
```

#### Interactive Development Session
```bash
# Request interactive GPU session
srun --gpus=1 --mem=32G --tmp=50G --time=2:00:00 --pty bash

# In the session, extract and use container
tar -xf /cluster/work/rsl/$USER/containers/dev.tar -C $TMPDIR

singularity shell --nv \
    --bind /cluster/project/rsl/$USER:/project \
    --bind /cluster/scratch/$USER:/data \
    $TMPDIR/dev.sif
```

## 📦 Container Workflow Scripts

### Container Test Suite
- **[Dockerfile](scripts/container-workflow/Dockerfile)** - GPU-enabled Docker image with CUDA 11.8
- **[hello_cluster.py](scripts/container-workflow/hello_cluster.py)** - GPU functionality test
- **[test_job_project.sh](scripts/container-workflow/test_job_project.sh)** - Complete container job
- **[test_container_extraction.sh](scripts/container-workflow/test_container_extraction.sh)** - Extraction timing test

### Build and Deploy Helper
```bash
#!/bin/bash
# build_and_deploy.sh

set -e

IMAGE_NAME=${1:-"my-app"}
VERSION=$(date +%Y%m%d-%H%M%S)

echo "Building ${IMAGE_NAME}:${VERSION}..."

# Build Docker image
docker build -t ${IMAGE_NAME}:${VERSION} .

# Convert to Singularity
echo "Converting to Singularity..."
apptainer build --sandbox --fakeroot \
    ${IMAGE_NAME}-${VERSION}.sif \
    docker-daemon://${IMAGE_NAME}:${VERSION}

# Compress
echo "Compressing..."
tar -czf ${IMAGE_NAME}-${VERSION}.tar.gz ${IMAGE_NAME}-${VERSION}.sif

# Transfer
echo "Transferring to Euler..."
scp ${IMAGE_NAME}-${VERSION}.tar.gz \
    euler:/cluster/work/rsl/$USER/containers/

echo "Done! Container available as ${IMAGE_NAME}-${VERSION}.tar.gz"
```

## 🔧 Utility Scripts

### Job Resource Monitor
```bash
#!/bin/bash
# monitor_job.sh

JOB_ID=$1

if [ -z "$JOB_ID" ]; then
    echo "Usage: $0 <job_id>"
    exit 1
fi

while true; do
    clear
    echo "=== Job $JOB_ID Status ==="
    squeue -j $JOB_ID
    
    echo -e "\n=== Resource Usage ==="
    sstat -j $JOB_ID --format=JobID,MaxRSS,MaxDiskRead,MaxDiskWrite
    
    # Get node name and check GPU
    NODE=$(squeue -j $JOB_ID -h -o %N)
    if [ ! -z "$NODE" ]; then
        echo -e "\n=== GPU Usage on $NODE ==="
        ssh $NODE nvidia-smi --query-gpu=index,name,utilization.gpu,memory.used,memory.total --format=csv
    fi
    
    sleep 5
done
```

### Batch Job Status Check
```bash
#!/bin/bash
# check_jobs.sh

echo "=== Your Current Jobs ==="
squeue -u $USER --format="%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R"

echo -e "\n=== Recently Completed Jobs ==="
sacct -u $USER --starttime=$(date -d '1 day ago' +%Y-%m-%d) \
    --format=JobID,JobName,State,ExitCode,Elapsed,MaxRSS

echo -e "\n=== Storage Usage ==="
lquota
```

## 📥 Download Scripts

Clone the entire repository to get all scripts:

```bash
git clone https://github.com/leggedrobotics/euler-cluster-guide.git
cd euler-cluster-guide/docs/scripts

# Make all scripts executable
find . -name "*.sh" -type f -exec chmod +x {} \;
```

Or download individual scripts:
```bash
# Example: Download the GPU test job
wget https://raw.githubusercontent.com/leggedrobotics/euler-cluster-guide/main/docs/scripts/computing-guide/test_gpu_job.sh
```

---

[Back to Home](/) | [Computing Guide](/computing-guide) | [Container Workflow](/container-workflow) | [Troubleshooting](/troubleshooting)