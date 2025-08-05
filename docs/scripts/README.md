# Test Scripts for Euler Cluster Container Workflow

This directory contains all the scripts used to test the container workflow on the Euler cluster.

## Files

### `hello_cluster.py`
A Python script that tests GPU availability and PyTorch functionality. This script:
- Detects available GPUs
- Performs a simple matrix multiplication on GPU
- Saves results to the output directory

### `Dockerfile`
A minimal Docker image for GPU computing with:
- CUDA 11.8 runtime
- PyTorch 2.0.1 with CUDA support
- Python 3.10

### `test_job_project.sh`
SLURM job script that:
- Extracts the container to local scratch (`$TMPDIR`)
- Runs the container with GPU support
- Saves results to the project partition
- Reports timing information

## Usage

1. **Build the Docker image locally:**
   ```bash
   docker build -t euler-test:latest .
   ```

2. **Convert to Singularity:**
   ```bash
   APPTAINER_NOHTTPS=1 apptainer build --sandbox --fakeroot euler-test.sif docker-daemon://euler-test:latest
   tar -cvf euler-test.tar euler-test.sif
   ```

3. **Transfer to Euler:**
   ```bash
   scp euler-test.tar euler:/cluster/work/rsl/$USER/containers/
   ```

4. **Submit the job:**
   ```bash
   sbatch test_job_project.sh
   ```

## Performance Results

From our testing on Euler cluster:
- Container size: 8.0GB
- Extraction time to `$TMPDIR`: ~10-15 seconds
- Container execution overhead: ~2 seconds
- GPU detection: < 1 second

## Tested Hardware

- NVIDIA GeForce RTX 2080 Ti
- NVIDIA GeForce RTX 4090