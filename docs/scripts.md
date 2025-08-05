# Scripts Library

This page contains ready-to-use scripts for the Euler cluster container workflow.

## Test Scripts

All scripts have been tested on the Euler cluster with the RSL group allocation.

### Python Test Script

**[hello_cluster.py](scripts/hello_cluster.py)**

A comprehensive GPU test script that:
- Detects available GPUs and CUDA version
- Performs matrix multiplication on GPU
- Saves results to output directory
- Reports system information

### Docker Configuration

**[Dockerfile](scripts/Dockerfile)**

A minimal GPU-enabled Docker image with:
- CUDA 11.8 runtime
- PyTorch 2.0.1 with CUDA support
- Python 3.10

### SLURM Job Script

**[test_job_project.sh](scripts/test_job_project.sh)**

Optimized job submission script that:
- Extracts container to local scratch for performance
- Allocates GPU resources
- Saves results to project partition
- Reports timing information

## Additional Examples

### Multi-GPU Training Script

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

# Extract container
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

### Interactive Development Session

```bash
# Request interactive GPU session
srun --gpus=1 --mem=32G --tmp=50G --time=2:00:00 --pty bash

# Extract container
tar -xf /cluster/work/rsl/$USER/containers/dev.tar -C $TMPDIR

# Enter container shell
singularity shell --nv \
    --bind /cluster/project/rsl/$USER:/project \
    --bind /cluster/scratch/$USER:/data \
    $TMPDIR/dev.sif
```

### Batch Processing Script

```bash
#!/bin/bash
#SBATCH --array=1-100
#SBATCH --job-name=batch-process
#SBATCH --output=logs/job_%A_%a.out
#SBATCH --error=logs/job_%A_%a.err
#SBATCH --time=1:00:00
#SBATCH --gpus=1
#SBATCH --tmp=50G

module load eth_proxy

# Extract container once
tar -xf /cluster/work/rsl/$USER/containers/processor.tar -C $TMPDIR

# Process specific file based on array index
singularity exec --nv \
    --bind /cluster/scratch/$USER/input:/input:ro \
    --bind /cluster/project/rsl/$USER/output:/output \
    $TMPDIR/processor.sif \
    python3 process.py --file /input/data_${SLURM_ARRAY_TASK_ID}.txt
```

## Helper Scripts

### Container Build and Deploy

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
APPTAINER_NOHTTPS=1 apptainer build --sandbox --fakeroot \
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

### Resource Monitor

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
    
    # Get node name
    NODE=$(squeue -j $JOB_ID -h -o %N)
    if [ ! -z "$NODE" ]; then
        echo -e "\n=== GPU Usage on $NODE ==="
        ssh $NODE nvidia-smi --query-gpu=index,name,utilization.gpu,memory.used,memory.total --format=csv
    fi
    
    sleep 5
done
```

## Download All Scripts

You can download all scripts as a ZIP file or clone the repository:

```bash
git clone https://github.com/leggedrobotics/euler-cluster-guide.git
cd euler-cluster-guide/docs/scripts
```

---

[Back to Home](/) | [Container Workflow](/container-workflow) | [Troubleshooting](/troubleshooting)