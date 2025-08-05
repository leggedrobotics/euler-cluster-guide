# RSL Euler Cluster Guide

Welcome to the comprehensive guide for using the Euler HPC cluster at ETH Zurich, specifically tailored for the Robotics Systems Lab (RSL) community.

## 🚀 Quick Navigation

!!! tip "Getting Started"
    New to Euler? Start with our [Complete Guide](complete-guide/) for detailed step-by-step instructions on accessing and using the cluster.

!!! example "Container Workflows" 
    Learn how to build, deploy, and run [containerized applications](container-workflow/) using Docker and Singularity on Euler.

!!! code "Scripts & Examples"
    Browse our [scripts library](scripts/) for ready-to-use SLURM job scripts, Docker examples, and automation tools.

!!! help "Troubleshooting"
    Find solutions to common issues in our [troubleshooting guide](troubleshooting/).

---

## 🎯 Quick Start

### First Time Setup
```bash
# 1. SSH into Euler
ssh <your_nethz_username>@euler.ethz.ch

# 2. Verify RSL group membership
my_share_info
# Should show: "You are a member of the es_hutter shareholder group"

# 3. Create your directories
mkdir -p /cluster/project/rsl/$USER
mkdir -p /cluster/work/rsl/$USER
```

### Submit Your First Job
```bash
# Create a simple test script
cat > test_job.sh << 'EOF'
#!/bin/bash
#SBATCH --job-name=test
#SBATCH --time=00:10:00
#SBATCH --mem=4G

echo "Hello from $(hostname)"
echo "Job ID: $SLURM_JOB_ID"
EOF

# Submit it
sbatch test_job.sh
```

---

## 📊 Quick Reference

### Storage Locations
| Location | Quota | Purpose |
|----------|-------|---------|
| `/cluster/home/$USER` | 45 GB | Code, configs |
| `/cluster/scratch/$USER` | 2.5 TB | Datasets (auto-deleted after 15 days) |
| `/cluster/project/rsl/$USER` | 75 GB | Conda environments |
| `/cluster/work/rsl/$USER` | 150 GB | Results, containers |
| `$TMPDIR` | 800 GB | Fast local scratch (per job) |

### Essential Commands
```bash
# Job Management
sbatch script.sh          # Submit job
squeue -u $USER          # Check your jobs
scancel <job_id>         # Cancel job

# Interactive Sessions
srun --pty bash          # Basic session
srun --gpus=1 --pty bash # GPU session

# Storage Check
lquota                   # Check home/scratch usage
```

### GPU Resources
```bash
# Request specific GPU types
#SBATCH --gpus=1                            # Any available GPU
#SBATCH --gpus=nvidia_geforce_rtx_4090:1    # RTX 4090 (24GB)
#SBATCH --gpus=nvidia_a100_80gb_pcie:1      # A100 (80GB)
```

---

## 🚀 Common Workflows

### GPU Training Job
```bash
#!/bin/bash
#SBATCH --job-name=training
#SBATCH --gpus=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --tmp=100G

module load eth_proxy
python train.py
```

### Container Workflow
```bash
# 1. Build locally
docker build -t myapp:latest .

# 2. Convert to Singularity
apptainer build --sandbox myapp.sif docker-daemon://myapp:latest
tar -cf myapp.tar myapp.sif

# 3. Transfer & run on Euler
scp myapp.tar euler:/cluster/work/rsl/$USER/
# Then use in job script:
tar -xf /cluster/work/rsl/$USER/myapp.tar -C $TMPDIR
singularity exec --nv $TMPDIR/myapp.sif python app.py
```

### Interactive Development
```bash
# JupyterHub: https://jupyter.euler.hpc.ethz.ch
# Or command line:
srun --gpus=1 --mem=32G --time=2:00:00 --pty bash
```

---

## 📚 Documentation Structure

- **[Complete Guide](complete-guide/)** - Comprehensive setup and detailed instructions
- **[Container Workflow](container-workflow/)** - Full Docker/Singularity workflow with examples
- **[Scripts Library](scripts/)** - Ready-to-use job scripts and templates
- **[Troubleshooting](troubleshooting/)** - Solutions to common problems

---

## 🆘 Getting Help

### Quick Links
- **Access Form**: [RSL Cluster Access](https://forms.gle/UsiGkXUmo9YyNHsH8)
- **RSL Contact**: Manthan Patel (patelm@ethz.ch)
- **ETH IT Support**: [ServiceDesk](https://ethz.ch/services/en/it-services/help.html)
- **Official Docs**: [Euler Wiki](https://scicomp.ethz.ch/wiki/Euler)

### Prerequisites
✅ Valid nethz account  
✅ RSL group membership (es_hutter)  
✅ Terminal access  
✅ Basic Linux/SLURM knowledge  

---

## 🎓 Tips for Success

!!! success "Do's"
    - Use `$TMPDIR` for I/O intensive operations
    - Request only the resources you need
    - Use containers for reproducible environments
    - Save important results to `/cluster/work/rsl/$USER`

!!! warning "Don'ts"
    - Don't run computations on login nodes
    - Don't exceed storage quotas
    - Don't leave interactive sessions idle
    - Don't store data only in scratch (auto-deleted!)

---

*Maintained by the Robotics Systems Lab (RSL), ETH Zurich*