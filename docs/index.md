# RSL Euler Cluster Guide

## 🚀 Quick Access to All Sections

### 1. Getting Started
**[Access Requirements, SSH Setup, Verification →](getting-started.md)**
- Getting cluster access
- Setting up SSH connection
- Verifying RSL group membership

### 2. Data Management
**[Storage Locations and Quotas →](data-management.md)**
- Home, Scratch, Project, Work directories
- Storage quotas and best practices
- Using local scratch ($TMPDIR)

### 3. Python Environments & ML Training
**[Miniconda Setup and Training Workflows →](python-environments.md)**
- Installing and managing Miniconda
- Creating conda environments
- Complete ML training workflow

### 4. Computing on Euler
**[Interactive Sessions and Batch Jobs →](computing-guide.md)**
- Requesting interactive sessions
- Writing and submitting SLURM job scripts
- GPU selection and multi-GPU training

### 5. Container Workflow
**[Docker/Singularity Guide →](container-workflow.md)**
- Building Docker containers
- Converting to Singularity
- Running containerized jobs

### 📚 Additional Resources
- **[Complete Reference Guide](complete-guide.md)** - All sections in one document
- **[Scripts Library](scripts.md)** - Ready-to-use job scripts
- **[Troubleshooting](troubleshooting.md)** - Common issues and solutions

## 🎯 Quick Start

```bash
# SSH to Euler
ssh <nethz_username>@euler.ethz.ch

# Check RSL membership
my_share_info

# Submit a job
sbatch job.sh
```

---

*Maintained by the Robotics Systems Lab (RSL), ETH Zurich*