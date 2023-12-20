#!/bin/bash

# download VM image
cd /script/vm-lib/images
sh download.sh

# setup bridge
cd /home/work && sh /script/bridge-init.sh

cat <<EOL > /home/work/br0/.network-settings
BRIDGENAME=br0
NETWORK=10.107.25.0 
NETMASK=255.255.255.0 
GATEWAY=10.107.25.1
DHCPRANGE=10.107.25.4,10.107.25.10
EOL

cd /home/work/br0 && sh /home/work/br0/create.sh

# setup vm0
cd /home/work
sh /script/vm-init.sh vm0

cd /home/work/vm0

cat <<EOL > /home/work/vm0/.vm-settings
VMNAME=vm0
VMMACADDRESS=00:00:00:12:34:56
VMMONITORPORT=30009
VMSERIALPORT=30006
VMWEBVNCPORT=30005
VMVNCPORT=1  #mulai dari 5900
VMVNCPASSWORD=729b75b5
VMSIZE=3G
VMMEMORY=2048
VMCPU=2
VMIMAGELOCATION=/script/vm-lib/images/cloud-image.img
NETBRIDGE=br0
EOL

cat <<EOL > /home/work/vm0/network-config.cfg
version: 2
ethernets:
    ens3:
      dhcp4: true
      gateway4: 10.107.25.1
      nameservers:
          search: [its.ac.id]
          addresses: [8.8.8.8]
EOL

cat <<EOL > /home/work/vm0/user-data.cfg
#cloud-config
instance-id: vm0
local-hostname: host-vm0
hostname: host-vm0
manage_etc_hosts: false
ssh_pwauth: true
disable_root: false
users:
  - default
  - name: ubuntu
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: false
chpasswd:
  list: |
    root:password
    ubuntu:Kelas2023
  expire: false
bootcmd:
- uuidgen | md5sum | cut -d" " -f1 > /etc/machine-id
EOL

cd /home/work/vm0 && sh /home/work/vm0/update.sh && sh /home/work/vm0/create.sh

# setup vm1
cd /home/work
sh /script/vm-init.sh vm1

cd /home/work/vm1

cat <<EOL > /home/work/vm1/.vm-settings
VMNAME=vm1
VMMACADDRESS=00:00:00:12:34:57
VMMONITORPORT=30010
VMSERIALPORT=30008
VMWEBVNCPORT=30007
VMVNCPORT=2  #mulai dari 5900
VMVNCPASSWORD=ba2f6fbe
VMSIZE=3G
VMMEMORY=2048
VMCPU=2
VMIMAGELOCATION=/script/vm-lib/images/cloud-image.img
NETBRIDGE=br0
EOL

cat <<EOL > /home/work/vm1/network-config.cfg
version: 2
ethernets:
    ens3:
      dhcp4: true
      gateway4: 10.107.25.1
      nameservers:
          search: [its.ac.id]
          addresses: [8.8.8.8] 
EOL

cat <<EOL > /home/work/vm1/user-data.cfg
#cloud-config
instance-id: vm1
local-hostname: host-vm1
hostname: host-vm1
manage_etc_hosts: false
ssh_pwauth: true
disable_root: false
users:
  - default
  - name: ubuntu
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: false
chpasswd:
  list: |
    root:password
    ubuntu:Kelas2023
  expire: false
bootcmd:
- uuidgen | md5sum | cut -d" " -f1 > /etc/machine-id
EOL

cd /home/work/vm1 && sh /home/work/vm1/update.sh && sh /home/work/vm1/create.sh

