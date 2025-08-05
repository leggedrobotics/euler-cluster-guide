---
layout: default
title: Troubleshooting
---

# Troubleshooting Guide

This page covers common issues and solutions when working with containers on the Euler cluster.

## Common Issues

### Container Build Issues

#### Docker daemon not running
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```
**Solution**: Start Docker service
```bash
sudo systemctl start docker
# or on macOS:
open -a Docker
```

#### Apptainer/Singularity not found
```
bash: apptainer: command not found
```
**Solution**: Install Apptainer (v1.2.5 recommended)
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y apptainer

# From source (recommended for version control)
wget https://github.com/apptainer/apptainer/releases/download/v1.2.5/apptainer-1.2.5.tar.gz
```

### Transfer Issues

#### Connection timeout during SCP
```
ssh: connect to host euler.ethz.ch port 22: Connection timed out
```
**Solution**: 
- Check VPN connection if off-campus
- Use ETH proxy: `module load eth_proxy`
- Try alternative transfer method:
```bash
# Use rsync with resume capability
rsync -avP --append-verify container.tar euler:/cluster/work/rsl/$USER/containers/
```

#### Insufficient space during transfer
```
scp: write: No space left on device
```
**Solution**: Check quotas and clean up
```bash
# Check your quotas
lquota

# Clean old containers
rm /cluster/work/rsl/$USER/containers/old-*.tar
```

### SLURM Job Issues

#### Job stays pending
```
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
12345    gpu.4h container   user PD       0:00      1 (Resources)
```
**Solution**: 
- Reduce resource requirements
- Check available resources: `sinfo -o "%P %a %l %D %G"`
- Use different partition: `#SBATCH --partition=gpu.24h`

#### Container extraction fails
```
tar: my-app.sif: Cannot open: No such file or directory
```
**Solution**: Verify container path
```bash
# List available containers
ls -la /cluster/work/rsl/$USER/containers/

# Check if extraction completed
ls -la $TMPDIR/
```

#### GPU not detected
```
CUDA available: False
```
**Solution**: 
1. Check job allocation:
```bash
echo $CUDA_VISIBLE_DEVICES  # Should show GPU ID
nvidia-smi  # Should list GPUs
```

2. Verify `--nv` flag in singularity command
3. Check CUDA version compatibility:
```bash
singularity exec --nv container.sif nvidia-smi
```

### Runtime Issues

#### Out of memory (OOM)
```
RuntimeError: CUDA out of memory
```
**Solution**:
- Reduce batch size
- Use gradient accumulation
- Request more memory: `#SBATCH --mem-per-cpu=8G`
- Monitor memory usage:
```python
import torch
print(f"Allocated: {torch.cuda.memory_allocated()/1024**3:.2f} GB")
print(f"Reserved: {torch.cuda.memory_reserved()/1024**3:.2f} GB")
```

#### Permission denied
```
Permission denied: '/output/results.txt'
```
**Solution**: 
- Create output directory first
- Check bind mount syntax
- Use proper permissions:
```bash
mkdir -p /cluster/project/rsl/$USER/output
chmod 755 /cluster/project/rsl/$USER/output
```

#### Slow I/O performance
**Solution**: Always use local scratch
```bash
# Good - use $TMPDIR
cp /cluster/scratch/$USER/data.tar $TMPDIR/
tar -xf $TMPDIR/data.tar -C $TMPDIR/

# Bad - network I/O
tar -xf /cluster/scratch/$USER/data.tar -C /cluster/work/$USER/
```

## Debugging Techniques

### Interactive Debugging

Start an interactive session:
```bash
# Request resources
srun --gpus=1 --mem=16G --tmp=50G --time=1:00:00 --pty bash

# Extract container
tar -xf /cluster/work/rsl/$USER/containers/debug.tar -C $TMPDIR

# Enter container interactively
singularity shell --nv $TMPDIR/debug.sif

# Test commands manually
python3 -c "import torch; print(torch.cuda.is_available())"
```

### Verbose Output

Add debugging to job scripts:
```bash
#!/bin/bash
#SBATCH --job-name=debug-job

# Enable bash debugging
set -x

# Print environment
echo "=== Environment ==="
env | grep -E "(CUDA|SINGULARITY|SLURM)" | sort

# Check allocations
echo "=== Allocations ==="
echo "GPUs: $CUDA_VISIBLE_DEVICES"
echo "CPUs: $SLURM_CPUS_PER_TASK"
echo "Memory: $SLURM_MEM_PER_CPU MB per CPU"
echo "Tmp space: $(df -h $TMPDIR | tail -1)"

# Time each step
echo "=== Extraction ==="
time tar -xf container.tar -C $TMPDIR

echo "=== Container Info ==="
singularity inspect $TMPDIR/container.sif
```

### Common Debug Commands

```bash
# Check job details
scontrol show job $SLURM_JOB_ID

# Monitor resource usage
watch -n 1 'sstat -j $SLURM_JOB_ID --format=JobID,MaxRSS,MaxDiskRead,MaxDiskWrite'

# Check GPU usage on node
ssh $NODE 'nvidia-smi -l 1'

# View detailed job info after completion
sacct -j $SLURM_JOB_ID --format=JobID,JobName,Partition,State,ExitCode,Elapsed,MaxRSS,AllocGRES

# Check why job failed
scontrol show job $SLURM_JOB_ID | grep -E "(Reason|ExitCode)"
```

## Performance Optimization

### Container Size Optimization

Reduce container size:
```dockerfile
# Multi-stage build
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 AS builder
RUN apt-get update && apt-get install -y build-essential
# Build steps...

FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
COPY --from=builder /app/bin /app/bin
# Minimal runtime dependencies only
```

### Data Loading Optimization

```python
# Use local scratch for datasets
import os
import shutil

# Copy dataset to local scratch at job start
if os.environ.get('SLURM_JOB_ID'):
    local_data = f"{os.environ['TMPDIR']}/dataset"
    if not os.path.exists(local_data):
        shutil.copytree('/cluster/scratch/user/dataset', local_data)
    data_path = local_data
else:
    data_path = './dataset'

# Use multiple workers for data loading
dataloader = DataLoader(dataset, 
                       batch_size=32,
                       num_workers=8,  # Match CPU count
                       pin_memory=True,
                       persistent_workers=True)
```

## Getting Help

### RSL-Specific Support
- Contact your supervisor
- Email Manthan Patel for group access issues
- Check RSL wiki for lab-specific guidelines

### Cluster Support
- ETH IT ServiceDesk: [help.ethz.ch](https://help.ethz.ch)
- HPC mailing list: hpc@id.ethz.ch
- Euler documentation: [scicomp.ethz.ch/wiki](https://scicomp.ethz.ch/wiki)

### Community Resources
- [GitHub Issues](https://github.com/leggedrobotics/euler-cluster-guide/issues)
- RSL Slack channels
- ETH HPC user meetings

---

[Back to Home](/) | [Container Workflow](/container-workflow) | [Scripts](/scripts)