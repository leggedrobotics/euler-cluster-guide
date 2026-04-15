#!/bin/bash
#SBATCH --job-name=test-storage
#SBATCH --output=test_storage_%j.out
#SBATCH --error=test_storage_%j.err
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --tmp=10G

echo "Storage Quota and Path Test"
echo "==========================="
echo "Job ID: $SLURM_JOB_ID"
echo "Running on: $(hostname)"
echo "Date: $(date)"
echo ""

# Test home directory
echo "1. Home Directory (/cluster/home/$USER)"
echo "----------------------------------------"
echo "Path exists: $([ -d /cluster/home/$USER ] && echo '✓ Yes' || echo '✗ No')"
df -h /cluster/home/$USER
echo ""

# Test scratch directory
echo "2. Scratch Directory (/cluster/scratch/$USER)"
echo "----------------------------------------"
if [ -d /cluster/scratch/$USER ]; then
    echo "Path exists: ✓ Yes"
    df -h /cluster/scratch/$USER
else
    echo "Path exists: ✗ No - Creating..."
    mkdir -p /cluster/scratch/$USER
fi
echo ""

# Test project directory
echo "3. Project Directory (/cluster/project/rsl/$USER)"
echo "----------------------------------------"
echo "Path exists: $([ -d /cluster/project/rsl/$USER ] && echo '✓ Yes' || echo '✗ No')"
df -h /cluster/project/rsl/$USER 2>/dev/null || echo "Not accessible"
echo ""

# Test work directory
echo "4. Work Directory (/cluster/work/rsl/$USER)"
echo "----------------------------------------"
echo "Path exists: $([ -d /cluster/work/rsl/$USER ] && echo '✓ Yes' || echo '✗ No')"
df -h /cluster/work/rsl/$USER 2>/dev/null || echo "Not accessible"
echo ""

# Test local scratch
echo "5. Local Scratch ($TMPDIR)"
echo "----------------------------------------"
echo "Path: $TMPDIR"
echo "Path exists: $([ -d $TMPDIR ] && echo '✓ Yes' || echo '✗ No')"
df -h $TMPDIR
echo ""

# Check quotas
echo "6. Quota Information"
echo "----------------------------------------"
echo "Home and Scratch quotas:"
lquota

echo ""
echo "RSL Project/Work usage:"
echo "Project directory:"
(head -n 5 && grep -w $USER) < /cluster/project/rsl/.rsl_user_data_usage.txt 2>/dev/null || echo "Usage data not available"
echo ""
echo "Work directory:"
(head -n 5 && grep -w $USER) < /cluster/work/rsl/.rsl_user_data_usage.txt 2>/dev/null || echo "Usage data not available"

echo ""
echo "Test completed!"