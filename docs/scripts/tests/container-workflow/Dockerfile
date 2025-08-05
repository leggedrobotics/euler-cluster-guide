FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Install Python and pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install PyTorch
RUN pip3 install --no-cache-dir torch==2.0.1 --index-url https://download.pytorch.org/whl/cu118

# Set working directory
WORKDIR /workspace

# Copy test script
COPY hello_cluster.py .

# Make script executable
RUN chmod +x hello_cluster.py

# Set entrypoint
ENTRYPOINT ["python3", "hello_cluster.py"]