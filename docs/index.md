---
layout: home
title: Home
nav_order: 1
description: "Comprehensive guide for using Docker containers on the Euler cluster at ETH Zurich"
permalink: /
---

# Euler Cluster Guide
{: .fs-9 }

A comprehensive guide for the Legged Robotics community at ETH Zurich
{: .fs-6 .fw-300 }

[Get started now](#getting-started){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 } [View on GitHub](https://github.com/leggedrobotics/euler-cluster-guide){: .btn .fs-5 .mb-4 .mb-md-0 }

---

## About this guide

This guide provides a complete workflow for deploying containerized applications on ETH Zurich's Euler cluster, specifically tailored for the **Legged Robotics** community. Whether you're running robot simulations, training neural networks, or processing sensor data, this guide will help you leverage the cluster's computational resources effectively.

### What you'll learn

{: .highlight }
> 📦 **Containerization** - Build and optimize Docker containers for HPC environments
>
> 🔄 **Conversion** - Transform Docker images to Singularity format for cluster compatibility
>
> 🚀 **Deployment** - Submit and manage GPU-accelerated jobs using SLURM
>
> ⚡ **Optimization** - Maximize performance for robotics and ML workloads

## Getting started

### Prerequisites
{: .fs-6 }

Before you begin, ensure you have:

- ✅ Access to the Euler cluster (RSL group membership)
- ✅ Docker installed locally (v24.0.7)
- ✅ Apptainer/Singularity installed (v1.2.5)
- ✅ Basic familiarity with SLURM

### Tested configuration
{: .fs-6 }

<div class="code-example" markdown="1">
| Component | Version/Specification |
|:----------|:---------------------|
| **Docker** | 24.0.7 |
| **Apptainer** | 1.2.5 |
| **Cluster** | Euler (ETH Zurich) |
| **GPUs** | RTX 2080 Ti, RTX 4090 |
| **Performance** | 10-15s extraction, 2s startup |
</div>

---

## Documentation sections

<div class="grid">
  <div class="col-4 col-md-4 p-3">
    <h3 class="fs-5">📦 Container Workflow</h3>
    <p>Step-by-step guide for building, converting, and deploying containers</p>
    <p><a href="container-workflow/">Learn more →</a></p>
  </div>
  <div class="col-4 col-md-4 p-3">
    <h3 class="fs-5">📝 Scripts Library</h3>
    <p>Ready-to-use scripts for common tasks and workflows</p>
    <p><a href="scripts/">Browse scripts →</a></p>
  </div>
  <div class="col-4 col-md-4 p-3">
    <h3 class="fs-5">🔧 Troubleshooting</h3>
    <p>Solutions to common issues and optimization tips</p>
    <p><a href="troubleshooting/">Get help →</a></p>
  </div>
</div>

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