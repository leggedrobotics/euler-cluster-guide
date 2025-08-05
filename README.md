# Euler Cluster Guide for Legged Robotics

A comprehensive guide for using Docker containers on the Euler cluster at ETH Zurich, specifically tailored for the Legged Robotics community.

## 📚 Documentation

The full documentation is available at: https://leggedrobotics.github.io/euler-cluster-guide/

## 🚀 Quick Start

1. **Build Docker container**
   ```bash
   docker build -t my-app:latest .
   ```

2. **Convert to Singularity**
   ```bash
   apptainer build --sandbox --fakeroot my-app.sif docker-daemon://my-app:latest
   tar -cvf my-app.tar my-app.sif
   ```

3. **Transfer to Euler**
   ```bash
   scp my-app.tar euler:/cluster/work/rsl/$USER/containers/
   ```

4. **Submit job**
   ```bash
   sbatch job_script.sh
   ```

## 📁 Repository Structure

```
euler-cluster-guide/
├── euler_cluster_guide.md    # Complete guide with Section 9 filled
├── docs/                     # GitHub Pages documentation
│   ├── index.md             # Homepage
│   ├── container-workflow.md # Detailed workflow
│   ├── scripts.md           # Scripts library
│   ├── troubleshooting.md   # Common issues and solutions
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

This guide is provided by the Legged Robotics Lab at ETH Zurich for educational purposes.

---

*Maintained by the Legged Robotics Lab, ETH Zurich*