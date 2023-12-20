#!/bin/bash

br_total=0
vm_total=0
br_active=0
vm_active=0

# Check available bridges
echo "Available bridges:"
for dir in "/home/work"/br*; do
    if [ -d "$dir" ]; then
        echo "$(basename "$dir")"
        br_total=$((br_total+1))
    fi
done
echo "Total bridges: $br_total\n"

# Check available VMs
echo "Available VMs:"
for dir in "/home/work"/vm*; do
    if [ -d "$dir" ]; then
        echo "$(basename "$dir")"
        vm_total=$((vm_total+1))
    fi
done
echo "Total VMs: $vm_total\n"

# Check active bridges
echo "Active bridges:"
active_bridges=$(ps ax | grep "dnsmasq" | grep -oP -- '--interface=\K[^ ]+')
echo "$active_bridges" | sort -u
br_active=$(echo "$active_bridges" | wc -l)
echo "Total active bridges: $br_active\n"

# Check active VMs
for vm_dir in /home/work/vm*; do
    if [ -d "$vm_dir" ]; then
        vm_settings_file="$vm_dir/.vm-settings"
        if [ -f "$vm_settings_file" ]; then
            VMNAME=$(grep 'VMNAME=' "$vm_settings_file" | cut -d'=' -f2)
            VMMONITORPORT=$(grep 'VMMONITORPORT=' "$vm_settings_file" | cut -d'=' -f2)
            VMSERIALPORT=$(grep 'VMSERIALPORT=' "$vm_settings_file" | cut -d'=' -f2)
            VMWEBVNCPORT=$(grep 'VMWEBVNCPORT=' "$vm_settings_file" | cut -d'=' -f2)
            if netstat -ltnp | grep -q ":$VMMONITORPORT\|$VMSERIALPORT\|$VMWEBVNCPORT "; then
                echo "$VMNAME"
                vm_active=$((vm_active+1))
            fi
        fi
    fi
done
echo "Total active VMs: $vm_active" 
