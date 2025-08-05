#!/usr/bin/env python3
"""Simple test script for container workflow on Euler cluster."""

import os
import socket
import datetime
import torch

def main():
    print("="*50)
    print("Container Test on Euler Cluster")
    print("="*50)
    
    # System information
    print(f"Hostname: {socket.gethostname()}")
    print(f"Current time: {datetime.datetime.now()}")
    print(f"Working directory: {os.getcwd()}")
    
    # Python environment
    print(f"Python executable: {os.sys.executable}")
    print(f"Python version: {os.sys.version}")
    
    # PyTorch information
    print(f"\nPyTorch version: {torch.__version__}")
    print(f"CUDA available: {torch.cuda.is_available()}")
    if torch.cuda.is_available():
        print(f"CUDA version: {torch.version.cuda}")
        print(f"Number of GPUs: {torch.cuda.device_count()}")
        for i in range(torch.cuda.device_count()):
            print(f"GPU {i}: {torch.cuda.get_device_name(i)}")
    
    # Test computation
    print("\nPerforming simple computation...")
    x = torch.randn(1000, 1000)
    if torch.cuda.is_available():
        x = x.cuda()
        y = torch.matmul(x, x)
        print(f"Matrix multiplication result shape: {y.shape}")
        print(f"Computation device: {y.device}")
    else:
        y = torch.matmul(x, x)
        print(f"Matrix multiplication result shape: {y.shape}")
        print("Computation performed on CPU")
    
    # Write output file
    output_file = "/output/test_results.txt"
    if os.path.exists("/output"):
        with open(output_file, "w") as f:
            f.write(f"Test completed at {datetime.datetime.now()}\n")
            f.write(f"Hostname: {socket.gethostname()}\n")
            f.write(f"PyTorch version: {torch.__version__}\n")
            f.write(f"CUDA available: {torch.cuda.is_available()}\n")
        print(f"\nResults written to: {output_file}")
    
    print("\nTest completed successfully!")
    print("="*50)

if __name__ == "__main__":
    main()