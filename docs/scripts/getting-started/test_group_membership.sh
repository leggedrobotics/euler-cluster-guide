#!/bin/bash
# Test script to verify RSL group membership and create directories

echo "Testing RSL Group Access"
echo "========================"
echo "User: $USER"
echo "Date: $(date)"
echo ""

# Check shareholder group membership
echo "Checking group membership..."
my_share_info

# Check if user is in es_hutter group
if my_share_info | grep -q "es_hutter"; then
    echo "✓ Confirmed: You are a member of the es_hutter shareholder group"
else
    echo "✗ ERROR: You are NOT a member of the es_hutter group"
    echo "Please contact your supervisor to be added to the group"
    exit 1
fi

echo ""
echo "Creating user directories..."

# Create directories
for dir in /cluster/project/rsl/$USER /cluster/work/rsl/$USER; do
    if [ -d "$dir" ]; then
        echo "✓ Directory already exists: $dir"
    else
        echo "Creating $dir..."
        mkdir -p "$dir"
        if [ $? -eq 0 ]; then
            echo "✓ Successfully created: $dir"
        else
            echo "✗ Failed to create: $dir"
        fi
    fi
done

echo ""
echo "Test completed!"