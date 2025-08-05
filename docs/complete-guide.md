# Complete RSL Euler Cluster Guide

This guide provides comprehensive documentation for using the Euler HPC cluster at ETH Zurich as a member of the Robotics Systems Lab (RSL).

## 📚 Guide Sections

### 1. [Getting Started](getting-started.md)
- Access requirements and approval process
- SSH configuration and key setup
- Verifying RSL group membership
- Initial setup script

### 2. [Data Management](data-management.md)
- Understanding storage locations (home, scratch, project, work)
- Storage quotas and limits
- Best practices for data organization
- Using local scratch ($TMPDIR) effectively

### 3. [Python Environments & ML Training](python-environments.md)
- Installing Miniconda in the correct location
- Creating and managing conda environments
- Complete ML training workflow example
- Performance optimization tips

### 4. [Computing on Euler](computing-guide.md)
- Interactive sessions for development
- Writing SLURM batch job scripts
- GPU selection and memory management
- Job monitoring and debugging

### 5. [Container Workflow](container-workflow.md)
- Building Docker containers locally
- Converting to Singularity format
- Deploying and running on Euler
- Performance considerations

## 🔧 Additional Resources

- **[Scripts Library](scripts.md)** - Ready-to-use SLURM scripts and examples
- **[Troubleshooting](troubleshooting.md)** - Common issues and solutions

## 🚀 Quick Start Checklist

1. ✅ Get access approval (fill out [form](https://forms.gle/UsiGkXUmo9YyNHsH8) or contact Manthan Patel)
2. ✅ Set up SSH keys and config
3. ✅ Run the setup script to verify access and create directories
4. ✅ Install Miniconda in `/cluster/project/rsl/$USER/`
5. ✅ Test with an interactive session
6. ✅ Submit your first batch job

## 📞 Support

- **RSL-specific issues**: Contact your supervisor or Manthan Patel
- **General Euler support**: [ETH IT ServiceDesk](https://ethz.ch/staffnet/en/it-services/catalogue/server-cluster/hpc-clusters.html)
- **Guide improvements**: [GitHub Issues](https://github.com/leggedrobotics/euler-cluster-guide/issues)

---

*This guide is maintained by the Robotics Systems Lab (RSL) at ETH Zurich*