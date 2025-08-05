# Data Management on Euler

Effective data management is critical when working on the Euler Cluster, particularly for machine learning workflows that involve large datasets and model outputs. This section explains the available storage options and their proper usage.

---

## 📁 Home Directory (`/cluster/home/$USER`)

- **Quota**: 45 GB  
- **Inodes**: ~450,000 files  
- **Persistence**: Permanent (not purged)
- **Use Case**: Ideal for storing source code, small configuration files, scripts, and lightweight development tools.

---

## ⚡ Scratch Directory (`/cluster/scratch/$USER` or `$SCRATCH`)

- **Quota**: 2.5 TB  
- **Inodes**: 1 M  
- **Persistence**: Temporary (data is deleted if not accessed for ~15 days)
- **Use Case**: For storing datasets and temporary training outputs.
- **Recommended Dataset storage format**: Use **tar/zip/[HDF5](https://www.hdfgroup.org/solutions/hdf5/)/[WebDataset](https://github.com/webdataset/webdataset)**.


---

## 📦 Project Directory (`/cluster/project/rsl/$USER`)

- **Quota**: ≤ 75 GB  
- **Inodes**: ~300,000  
- **Use Case**: Conda environments, software packages

---

## 📂 Work Directory (`/cluster/work/rsl/$USER`)

- **Quota**: ≤ 150 GB  
- **Inodes**: ~30,000  
- **Use Case**: Saving results, large output files, tar files, singularity images. Avoid storing too many small files.

> In exceptional cases we can approve more storage space. For this, ask your supervisor to contact `patelm@ethz.ch`.

## 📂 Local Scratch Directory (`$TMPDIR`)

- **Quota**: upto 800 GB  
- **Inodes**: Very High 
- **Use Case**: Datasets and containers for a training run. 

## ❗ Quota Violations:

- You shall receive an email if you violate any of the above limits. 
- You can type `lquota` in the terminal to check your used storage space for `Home` and `Scratch` directories. 
- For usage of `Project` and `Work` directories you can run: 
   ```bash 
   (head -n 5 && grep -w $USER) < /cluster/work/rsl/.rsl_user_data_usage.txt
   (head -n 5 && grep -w $USER) < /cluster/project/rsl/.rsl_user_data_usage.txt
   ```
   Note: This wont show the per-user quota limit which is enforced by RSL ! Refer to the table below for the quota limits.

### 🎯 FAQ: What is the difference between the `Project` and `Work` Directories and why is it necessary to make use of both?

Basically, both `Project` and `Work` are persistent storages (meaning the data is not deleted automatically); however, the use cases are different. When you have lots of small files, for example, conda environments, you should store them in the `Project` directory as it has a higher capacity for # of inodes. On the other hand, when you have larger files such as model checkpoints, singularity containers and results you should store them in the `Work` directory as the storage capacity is higher.

### 🎯 FAQ: What is Local Scratch Directory (`$TMPDIR`) ?

Whenever you run a compute job, you can also ask for a certain amount of local scratch space (`$TMPDIR`) which allocates space on a local hard drive. The main advantage of the local scratch is, that it is located directly inside the compute nodes and not attached via the network. Thus it is highly recommended to copy over your singularity container / datasets to `$TMPDIR` and then use that for the trainings. Detailed workflows for the trainings are provided later in this guide.

---

## 📊 Summary Table of Storage Locations

| Storage Location            | Max Inodes | Max Size per User | Purged | Recommended Use Case                               |
|----------------------------|------------|----------------|--------|----------------------------------------------------|
| `/cluster/home/$USER`      | ~450,000   | 45 GB          |      No     | Code, config, small files                          |
| `/cluster/scratch/$USER`   | 1 M    | 2.5 TB             |      Yes (older than 15 days)    | Datasets, training data, temporary usage           |
| `/cluster/project/rsl/$USER`     | 300,000    | 75 GB    |      No     | Conda envs, software packages             |
| `/cluster/work/rsl/$USER`        | 30,000     | 150 GB   |      No     | Large result files, model checkpoints, Singularity containers,             |
| `$TMPDIR`        | very high     | Upto 800 GB   |      Yes (at end of job)     |     Training Datasets, Singularity Images         |

---

## 💡 Best Practices

1. **Use the right storage for the right purpose** - Don't waste home directory space on large files
2. **Compress datasets** - Use tar/zip to reduce inode usage
3. **Clean up regularly** - Remove old data from scratch before it's auto-deleted
4. **Monitor your usage** - Check quotas regularly with `lquota`
5. **Use `$TMPDIR` for active jobs** - Copy data to local scratch for faster I/O during computation