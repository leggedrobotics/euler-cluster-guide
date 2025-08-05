
---
layout: default
title: Complete Guide
nav_order: 5
has_children: false
permalink: /complete-guide/
---

# Complete Euler Cluster Guide
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

This guide is designed to help new users access and begin working on the **Euler Cluster** at ETH Zurich, specifically for members of the **RSL group (es_hutter)**. It walks you through the complete process of connecting to the cluster, setting up secure access, and verifying your group membership.

---

## 📌 Table of Contents

1. [Access Requirements](#1-access-requirements)
2. [Connecting to Euler via SSH](#2-connecting-to-euler-via-ssh)
   - [Basic Login](#21-basic-login)
   - [Setting Up SSH Keys (Recommended)](#22-setting-up-ssh-keys-recommended)
   - [Using an SSH Config File](#23-using-an-ssh-config-file)
3. [Verifying Access to the RSL Shareholder Group](#3-verifying-access-to-the-rsl-shareholder-group)

---

## 1. ✅ Access Requirements

In order to get access to the cluster, kindly fill up the following [form](https://forms.gle/UsiGkXUmo9YyNHsH8). If you are a member of RSL, directly message Manthan Patel to add you to the cluster. The access is approved twice a week (Tuesdays and Fridays).

Before proceeding, make sure you have:

- A valid **nethz username and password** (ETH Zurich credentials)
- Access to a **terminal** (Linux/macOS or Git Bash on Windows)
- (Optional) Some familiarity with command-line tools

---

## 2. 🔐 Connecting to Euler via SSH

You’ll connect to Euler using the Secure Shell (SSH) protocol. This allows you to log into a remote machine securely from your local computer.

---

### 2.1 Basic Login

To log into the Euler cluster, open a terminal and type:

```bash
ssh <your_nethz_username>@euler.ethz.ch
```

Replace `<your_nethz_username>` with your actual ETH Zurich login.

You will be asked to enter your ETH Zurich password. If the login is successful, you'll be connected to a login node on the Euler cluster.

---

### 2.2 Setting Up SSH Keys (Recommended)

To avoid typing your password every time and to increase security, it is recommended to use SSH key-based authentication.

#### Step-by-Step Instructions:

1. **Generate an SSH key pair** on your local machine (if not already created):

   ```bash
   ssh-keygen -t ed25519 -C "<your_email>@ethz.ch"
   ```

   - Press Enter to accept the default file location (usually `~/.ssh/id_ed25519`).
   - When prompted for a passphrase, you can choose to set one or leave it empty.

2. **Copy your public key to Euler** using this command:

   ```bash
   ssh-copy-id <your_nethz_username>@euler.ethz.ch
   ```

   - You'll be asked to enter your ETH password one last time.
   - This command installs your public key in the `~/.ssh/authorized_keys` file on Euler.

Now, you should be able to log in without typing your password.

---

### 2.3 Using an SSH Config File

To make your SSH workflow easier, especially if you frequently access Euler, create or edit the `~/.ssh/config` file on your local machine.

#### Example Configuration:

```sshconfig
Host euler
  HostName euler.ethz.ch
  User <your_nethz_username>
  Compression yes
  ForwardX11 yes
  IdentityFile ~/.ssh/id_ed25519
```

- Replace `<your_nethz_username>` with your actual ETH username.
- Save and close the file.

Now, instead of typing the full SSH command, you can simply connect using:

```bash
ssh euler
```

---

## 3. 🧾 Verifying Access to the RSL Shareholder Group

Once you are logged into the Euler cluster, it's important to confirm that you have been added to the appropriate shareholder group. This ensures you can access the computing resources allocated to your research group (in this case, the RSL group).

---

### 🔍 How to Check Your Group Membership

1. While connected to Euler (after logging in via SSH), run the following command in the terminal:

   ```bash
   my_share_info
   ```

2. If everything is correctly set up, you should see output similar to the following:

   ```
   You are a member of the es_hutter shareholder group on Euler.
   ```

3. This message confirms that you are part of the `es_hutter` group, which is the shareholder group for the RSL lab.

4. Create your user directories for storage by using the following command
   ```bash 
   mkdir /cluster/project/rsl/$USER
   mkdir /cluster/work/rsl/$USER
   ```

---

### ❗ If You Do NOT See This Message:

- Double-check with your supervisor whether you've been added to the group.
- It may take a few hours after being added for the change to propagate.

---

## 4. 💾 Data Management on Euler

Effective data management is critical when working on the Euler Cluster, particularly for machine learning workflows that involve large datasets and model outputs. This section explains the available storage options and their proper usage.

---

### 📁 Home Directory (`/cluster/home/$USER`)

- **Quota**: 45 GB  
- **Inodes**: ~450,000 files  
- **Persistence**: Permanent (not purged)
- **Use Case**: Ideal for storing source code, small configuration files, scripts, and lightweight development tools.

---

### ⚡ Scratch Directory (`/cluster/scratch/$USER` or `$SCRATCH`)

- **Quota**: 2.5 TB  
- **Inodes**: 1 M  
- **Persistence**: Temporary (data is deleted if not accessed for ~15 days)
- **Use Case**: For storing datasets and temporary training outputs.
- **Recommended Dataset storage format**: Use **tar/zip/[HDF5](https://www.hdfgroup.org/solutions/hdf5/)/[WebDataset](https://github.com/webdataset/webdataset)**.


---

### 📦 Project Directory (`/cluster/project/rsl/$USER`)

- **Quota**: ≤ 75 GB  
- **Inodes**: ~300,000  
- **Use Case**: Conda environments, software packages

---

### 📂 Work Directory (`/cluster/work/rsl/$USER`)

- **Quota**: ≤ 150 GB  
- **Inodes**: ~30,000  
- **Use Case**: Saving results, large output files, tar files, singularity images. Avoid storing too many small files.

> In exceptional cases we can approve more storage space. For this, ask your supervisor to contact `patelm@ethz.ch`.

### 📂 Local Scratch Directory (`$TMPDIR`)

- **Quota**: upto 800 GB  
- **Inodes**: Very High 
- **Use Case**: Datasets and containers for a training run. 

### ❗ Quota Violations:

- You shall receive an email if you violate any of the above limits. 
- You can type `lquota` in the terminal to check your used storage space for `Home` and `Scratch` directories. 
- For usage of `Project` and `Work` directories you can run: 
   ```bash 
   (head -n 5 && grep -w $USER) < /cluster/work/rsl/.rsl_user_data_usage.txt
   (head -n 5 && grep -w $USER) < /cluster/project/rsl/.rsl_user_data_usage.txt
   ```
   Note: This wont show the per-user quota limit which is enforced by RSL ! Refer to the table below for the quota limits.

#### 🎯 FAQ: What is the difference between the `Project` and `Work` Directories and why is it necessary to make use of both?

Basically, both `Project` and `Work` are persistent storages (meaning the data is not deleted automatically); however, the use cases are different. When you have lots of small files, for example, conda environments, you should store them in the `Project` directory as it has a higher capacity for # of inodes. On the other hand, when you have larger files such as model checkpoints, singularity containers and results you should store them in the `Work` directory as the storage capacity is higher.

#### 🎯 FAQ: What is Local Scratch Directory (`$TMPDIR`) ?

Whenever you run a compute job, you can also ask for a certain amount of local scratch space (`$TMPDIR`) which allocates space on a local hard drive. The main advantage of the local scratch is, that it is located directly inside the compute nodes and not attached via the network. Thus it is highly recommended to copy over your singularity container / datasets to `$TMPDIR` and then use that for the trainings. Detailed workflows for the trainings are provided later in this guide.

---

### 📊 Summary Table of Storage Locations

| Storage Location            | Max Inodes | Max Size per User | Purged | Recommended Use Case                               |
|----------------------------|------------|----------------|--------|----------------------------------------------------|
| `/cluster/home/$USER`      | ~450,000   | 45 GB          |      No     | Code, config, small files                          |
| `/cluster/scratch/$USER`   | 1 M    | 2.5 TB             |      Yes (older than 15 days)    | Datasets, training data, temporary usage           |
| `/cluster/project/rsl/$USER`     | 300,000    | 75 GB    |      No     | Conda envs, software packages             |
| `/cluster/work/rsl/$USER`        | 30,000     | 150 GB   |      No     | Large result files, model checkpoints, Singularity containers,             |
| `$TMPDIR`        | very high     | Upto 800 GB   |      Yes (at end of job)     |     Training Datasets, Singularity Images         |

---


## 5. 🐍 Setting Up Miniconda Environments

Python virtual environments are commonly used on Euler for managing dependencies in a clean, reproducible way. One of the best tools for this purpose is [**Miniconda**](https://www.anaconda.com/docs/getting-started/miniconda/main), a lightweight version of Anaconda.

---

### 📦 Installing Miniconda3

To install Miniconda3, follow these steps:

```bash
# Create a directory for Miniconda
mkdir -p /cluster/project/rsl/$USER/miniconda3

# Download the installer
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /cluster/project/rsl/$USER/miniconda3/miniconda.sh

# Run the installer silently
bash /cluster/project/rsl/$USER/miniconda3/miniconda.sh -b -u -p /cluster/project/rsl/$USER/miniconda3/

# Clean up the installer
rm /cluster/project/rsl/$USER/miniconda3/miniconda.sh

# Initialize conda for bash
/cluster/project/rsl/$USER/miniconda3/bin/conda init bash

# Prevent auto-activation of the base environment
conda config --set auto_activate_base false
```

---

### 🚫 Avoid Installing in Home Directory

Installing Miniconda in your home directory (`~/miniconda3`) is **not recommended** due to storage and inode limits.

Instead, install it in your **project directory**:

```bash
/cluster/project/rsl/$USER/miniconda3
```

#### ✅ If you've already installed Miniconda in your home directory:

You can move it to your project directory and create a symbolic link:

```bash
mv ~/miniconda3 /cluster/project/rsl/$USER/
ln -s /cluster/project/rsl/$USER/miniconda3 ~/miniconda3
```

This way, conda commands referencing `~/miniconda3` will still work, while the files reside in a directory with more storage and inode capacity.

---

### 🧪 Creating a Sample Conda Environment

Once Miniconda is installed and configured, you can create a new conda environment like this:

```bash
conda create -n myenv python=3.10
```

To activate the environment:

```bash
conda activate myenv
```

You can install packages as needed:

```bash
conda install numpy pandas matplotlib
```

To deactivate the environment:

```bash
conda deactivate
```

---

### 💡 Best Practices

- Always install environments in `/cluster/project/rsl/$USER/miniconda3` to avoid inode overflow in your home directory.
- Use a compute node for the installation process, so you can make use of the bandwidth and the I/O available there, but be sure to request more than an hour for your session, so the progress is not lost if there are a lot of packages to install.
- Export the list of installed packages as soon as you confirm that an environment is working as expected. Set a mnemonic file name for that list, and save it in a secure place, in case you need to install the environment again.
---

## 6. Interactive Sessions

## 7. Sample Sbatch Scripts

## 8. Sample Training Workflow (Conda)

## 9. Sample Container Workflow

For containerized applications (Docker/Singularity), we provide a comprehensive guide with tested workflows, scripts, and troubleshooting tips.

📦 **[View the Complete Container Workflow Guide →](../container-workflow/)**

This dedicated guide covers:

- Building and optimizing Docker containers for HPC
- Converting Docker images to Singularity format
- Transferring containers to Euler efficiently
- Writing SLURM job scripts for containerized applications
- Performance benchmarks and best practices
- Complete working examples with GPU support
- Troubleshooting common container issues

The container workflow has been tested with Docker 24.0.7 and Apptainer 1.2.5 on Euler's GPU nodes.


## 10. 🔗Useful Links

Here are some essential resources to help you navigate the Euler cluster and related tools:

- 📘 [Getting Started with Clusters](https://scicomp.ethz.ch/wiki/Getting_started_with_clusters)  
  A step-by-step introduction to using HPC clusters at ETH Zurich.

- 🖥️ [Getting Started with GPUs](https://scicomp.ethz.ch/wiki/Getting_started_with_GPUs)  
  Learn how to use GPUs on Euler, including job submission and specifying GPU requirements

- 🧠 [VSCode (via JupyterHub / Code-server)](https://scicomp.ethz.ch/wiki/JupyterHub#Code-server)  
  Run VSCode in the browser directly on Euler with JupyterHub integration.

- 💾 [Storage Systems](https://scicomp.ethz.ch/wiki/Storage_systems)  
  Understand the different types of storage on Euler and how to use them effectively.

- ❓ [FAQs](https://scicomp.ethz.ch/wiki/FAQ)  
  Frequently asked questions and solutions related to Euler and scientific computing.

- 🤖 [IsaacLab Workflow](https://isaac-sim.github.io/IsaacLab/main/source/deployment/index.html)  
  Deployment instructions and best practices for using IsaacLab on HPC systems.
