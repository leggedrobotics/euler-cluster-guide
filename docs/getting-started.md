# Getting Started with Euler

This guide helps new users access and begin working on the **Euler Cluster** at ETH Zurich, specifically for members of the **RSL group (es_hutter)**.

## 📌 Table of Contents

1. [Access Requirements](#access-requirements)
2. [Connecting to Euler via SSH](#connecting-to-euler-via-ssh)
   - [Basic Login](#basic-login)
   - [Setting Up SSH Keys](#setting-up-ssh-keys-recommended)
   - [Using an SSH Config File](#using-an-ssh-config-file)
3. [Verifying Access to the RSL Shareholder Group](#verifying-access-to-the-rsl-shareholder-group)

---

## ✅ Access Requirements

In order to get access to the cluster, kindly fill up the following [form](https://forms.gle/UsiGkXUmo9YyNHsH8). If you are a member of RSL, directly message Manthan Patel to add you to the cluster. The access is approved twice a week (Tuesdays and Fridays).

Before proceeding, make sure you have:

- A valid **nethz username and password** (ETH Zurich credentials)
- Access to a **terminal** (Linux/macOS or Git Bash on Windows)
- (Optional) Some familiarity with command-line tools

---

## 🔐 Connecting to Euler via SSH

You'll connect to Euler using the Secure Shell (SSH) protocol. This allows you to log into a remote machine securely from your local computer.

---

### Basic Login

To log into the Euler cluster, open a terminal and type:

```bash
ssh <your_nethz_username>@euler.ethz.ch
```

Replace `<your_nethz_username>` with your actual ETH Zurich login.

You will be asked to enter your ETH Zurich password. If the login is successful, you'll be connected to a login node on the Euler cluster.

---

### Setting Up SSH Keys (Recommended)

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

### Using an SSH Config File

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

## 🧾 Verifying Access to the RSL Shareholder Group

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

## Next Steps

Once you have verified your access:
- Learn about [Data Management](data-management.md) on Euler
- Set up [Python Environments](python-environments.md)
- Start [Computing](computing-guide.md) with interactive sessions or batch jobs