# RSL Euler Cluster Guide

A comprehensive guide for the Euler HPC cluster at ETH Zurich, specifically tailored for the Robotics Systems Lab (RSL) community.

## 📚 Documentation

The full documentation is available at: https://leggedrobotics.github.io/euler-cluster-guide/

## 🎯 Quick Start

New to Euler? Start here:
1. **[Getting Started](https://leggedrobotics.github.io/euler-cluster-guide/getting-started/)** - Access setup and verification
2. **[Data Management](https://leggedrobotics.github.io/euler-cluster-guide/data-management/)** - Storage locations and quotas
3. **[Python & ML](https://leggedrobotics.github.io/euler-cluster-guide/python-environments/)** - Miniconda and training workflows
4. **[Computing](https://leggedrobotics.github.io/euler-cluster-guide/computing-guide/)** - Interactive sessions and batch jobs
5. **[Containers](https://leggedrobotics.github.io/euler-cluster-guide/container-workflow/)** - Docker/Singularity workflows

## 📚 Additional Resources

- **[Complete Reference Guide](https://leggedrobotics.github.io/euler-cluster-guide/complete-guide/)** - All sections in one document
- **[Scripts Library](https://leggedrobotics.github.io/euler-cluster-guide/scripts/)** - Ready-to-use SLURM scripts and examples
- **[Troubleshooting](https://leggedrobotics.github.io/euler-cluster-guide/troubleshooting/)** - Common issues and solutions

## 📁 Repository Structure

```
euler-cluster-guide/
├── docs/                          # GitHub Pages documentation
│   ├── index.md                  # Homepage
│   ├── getting-started.md        # Access and SSH setup
│   ├── data-management.md        # Storage and quotas
│   ├── python-environments.md    # Miniconda and ML workflows
│   ├── computing-guide.md        # Interactive and batch jobs
│   ├── container-workflow.md     # Docker/Singularity guide
│   ├── complete-guide.md         # All sections combined
│   ├── scripts.md                # Scripts library
│   ├── troubleshooting.md        # Common issues
│   └── scripts/                  # Test scripts organized by section
│       ├── getting-started/      # Setup verification scripts
│       ├── data-management/      # Storage test scripts
│       ├── python-environments/  # ML workflow examples
│       ├── computing-guide/      # Job submission examples
│       └── container-workflow/   # Container test files
├── mkdocs.yml                    # MkDocs configuration
└── README.md                     # This file
```

## ✅ Tested Configuration

- **Docker**: 24.0.7
- **Apptainer**: 1.2.5
- **Cluster**: Euler (ETH Zurich)
- **GPUs**: NVIDIA RTX 2080 Ti, RTX 4090


## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/leggedrobotics/euler-cluster-guide/issues)
- **RSL Access**: Contact Manthan Patel
- **Cluster Support**: ETH IT ServiceDesk

## 📄 License

This guide is provided by the Robotics Systems Lab (RSL) at ETH Zurich for educational purposes.

---

*Maintained by the Robotics Systems Lab (RSL), ETH Zurich*