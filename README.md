# RSL Euler Cluster Guide

A comprehensive guide for the Euler HPC cluster at ETH Zurich, specifically tailored for the Robotics Systems Lab (RSL) community.

## 📚 Documentation

The full documentation is available at: https://leggedrobotics.github.io/euler-cluster-guide/

## 📖 What's Included

This guide covers everything you need to get started with the Euler cluster:

- **Access & Setup**: SSH configuration, group membership verification
- **Storage Management**: Understanding quotas and file systems
- **Computing Workflows**: Interactive sessions, batch jobs, GPU computing
- **Container Workflows**: Docker to Singularity conversion and deployment
- **Best Practices**: Performance optimization and troubleshooting

## 🚀 Quick Links

- [Complete Guide](https://leggedrobotics.github.io/euler-cluster-guide/complete-guide/) - Full documentation including SSH setup, storage, and computing basics
- [Container Workflow](https://leggedrobotics.github.io/euler-cluster-guide/container-workflow/) - Detailed guide for containerized applications
- [Scripts Library](https://leggedrobotics.github.io/euler-cluster-guide/scripts/) - Ready-to-use scripts and examples
- [Troubleshooting](https://leggedrobotics.github.io/euler-cluster-guide/troubleshooting/) - Common issues and solutions

## 📁 Repository Structure

```
euler-cluster-guide/
├── docs/                     # GitHub Pages documentation
│   ├── index.md             # Homepage
│   ├── complete-guide.md    # Full Euler guide (SSH, storage, etc.)
│   ├── container-workflow.md # Container workflow details
│   ├── scripts.md           # Scripts library
│   ├── troubleshooting.md   # Common issues and solutions
│   ├── assets/              # CSS and images
│   │   └── css/
│   │       └── style.scss   # Custom styling
│   └── scripts/             # Test scripts
│       ├── hello_cluster.py # GPU test script
│       ├── Dockerfile       # Example container
│       └── test_job_project.sh # SLURM job script
└── README.md               # This file
```

## ✅ Tested Configuration

- **Docker**: 24.0.7
- **Apptainer**: 1.2.5
- **Cluster**: Euler (ETH Zurich)
- **GPUs**: NVIDIA RTX 2080 Ti, RTX 4090
- **Container Size**: Up to 8GB
- **Performance**: 10-15s extraction, 2s startup

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/leggedrobotics/euler-cluster-guide/issues)
- **RSL Access**: Contact Manthan Patel
- **Cluster Support**: ETH IT ServiceDesk

## 📄 License

This guide is provided by the Robotics Systems Lab (RSL) at ETH Zurich for educational purposes.

---

*Maintained by the Robotics Systems Lab (RSL), ETH Zurich*