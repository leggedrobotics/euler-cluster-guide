---
layout: default
title: Home
---

# Euler Cluster Guide for Legged Robotics

Welcome to the comprehensive guide for using Docker containers on the Euler cluster at ETH Zurich, specifically tailored for the Legged Robotics community.

## 🚀 Quick Start

This guide will help you:
- Build and deploy Docker containers to Euler
- Convert Docker images to Singularity format
- Submit GPU-accelerated jobs using SLURM
- Optimize performance for robotics and ML workloads

## 📋 Prerequisites

Before starting, ensure you have:
- Access to the Euler cluster (RSL group membership)
- Docker installed locally (tested with v24.0.7)
- Apptainer/Singularity installed (tested with v1.2.5)
- Basic familiarity with SLURM job scheduling

## 🔧 Tested Configuration

This workflow has been thoroughly tested with:
- **Docker**: 24.0.7
- **Apptainer**: 1.2.5
- **Cluster**: Euler (ETH Zurich)
- **GPUs**: NVIDIA GeForce RTX 2080 Ti, RTX 4090
- **Container Size**: Up to 8GB
- **Performance**: 10-15s extraction time, 2s startup overhead

## 📚 Guide Contents

### [Container Workflow](container-workflow.html)
Complete step-by-step guide for building, converting, and running containers on Euler.

### [Scripts Library](scripts/)
Ready-to-use scripts including:
- Dockerfiles for common robotics/ML frameworks
- SLURM job templates
- Performance testing utilities
- Helper scripts for automation

### [Troubleshooting](troubleshooting.html)
Solutions to common issues and optimization tips.

## 🏃 Quick Example

```bash
# 1. Build your Docker image
docker build -t my-robot-sim:latest .

# 2. Convert to Singularity
apptainer build --sandbox my-robot-sim.sif docker-daemon://my-robot-sim:latest

# 3. Transfer to Euler
scp my-robot-sim.tar euler:/cluster/work/rsl/$USER/containers/

# 4. Submit job
sbatch run_simulation.sh
```

## 📊 Performance Benchmarks

Based on extensive testing on Euler:

| Operation | Time | Notes |
|-----------|------|-------|
| Container extraction (8GB) | 10-15s | To local scratch (`$TMPDIR`) |
| Container startup | ~2s | Including GPU initialization |
| GPU detection | <1s | CUDA 11.8 environment |
| File I/O | Varies | Use `$TMPDIR` for best performance |

## 🤝 Contributing

This guide is maintained by the Legged Robotics Lab at ETH Zurich. Contributions are welcome!

- Report issues: [GitHub Issues](https://github.com/leggedrobotics/euler-cluster-guide/issues)
- Submit improvements: [Pull Requests](https://github.com/leggedrobotics/euler-cluster-guide/pulls)

## 📞 Support

- **Cluster issues**: Contact ETH IT support
- **Guide questions**: Open an issue on GitHub
- **RSL-specific**: Contact your supervisor or Manthan Patel

## 🔗 Additional Resources

- [Official Euler Documentation](https://scicomp.ethz.ch/wiki/Euler)
- [Isaac Lab Cluster Guide](https://isaac-sim.github.io/IsaacLab/main/source/deployment/cluster.html)
- [ETH Zurich HPC Wiki](https://scicomp.ethz.ch/wiki)

---

*Last updated: August 2025 | Tested on Euler cluster with RSL group allocation*