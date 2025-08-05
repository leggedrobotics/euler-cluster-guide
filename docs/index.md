# RSL Euler Cluster Guide

Welcome to the comprehensive guide for using the Euler HPC cluster at ETH Zurich, specifically tailored for the Robotics Systems Lab (RSL) community.

<div class="grid cards" markdown>

- :material-rocket-launch: **Getting Started**  
  New to Euler? Start with our [Complete Guide](complete-guide.md) for step-by-step instructions on accessing and using the cluster.

- :material-docker: **Container Workflows**  
  Learn how to build, deploy, and run [containerized applications](container-workflow.md) using Docker and Singularity on Euler.

- :material-code-braces: **Scripts & Examples**  
  Browse our [scripts library](scripts.md) for ready-to-use SLURM job scripts, Docker examples, and automation tools.

- :material-help-circle: **Troubleshooting**  
  Find solutions to common issues in our [troubleshooting guide](troubleshooting.md).

</div>

## Quick Example

```bash
# Build your Docker image
docker build -t my-robot-sim:latest .

# Convert to Singularity
apptainer build --sandbox my-robot-sim.sif docker-daemon://my-robot-sim:latest

# Transfer to Euler
scp my-robot-sim.tar euler:/cluster/work/rsl/$USER/containers/

# Submit job
sbatch run_simulation.sh
```

## Prerequisites

Before you begin, ensure you have:

- ✅ Access to the Euler cluster (RSL group membership)
- ✅ Docker installed locally
- ✅ Apptainer/Singularity installed
- ✅ Basic familiarity with SLURM

## Key Features

- **GPU Computing**: Full support for NVIDIA GPUs (RTX 2080 Ti, RTX 4090, and more)
- **Container Support**: Seamless Docker to Singularity conversion workflows
- **Storage Options**: Multiple storage tiers for different use cases
- **Python Environments**: Conda/Mamba integration for package management
- **Interactive Sessions**: JupyterHub and VS Code support

## Tested Configuration

| Component | Version |
|-----------|---------|
| **Docker** | 24.0.7 |
| **Apptainer** | 1.2.5 |
| **Cluster** | Euler (ETH Zurich) |
| **Group** | es_hutter (RSL) |

## Support

- **Cluster Issues**: Contact ETH IT ServiceDesk
- **RSL Access**: Contact Manthan Patel
- **Guide Issues**: [GitHub Issues](https://github.com/leggedrobotics/euler-cluster-guide/issues)

---

*Maintained by the Robotics Systems Lab (RSL), ETH Zurich*