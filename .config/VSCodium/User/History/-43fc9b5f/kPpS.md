## Cluster Configuration

This Ansible script deploys a Kubernetes cluster with a Debian 12 base and CRI-O as container runtime.

### Features

- Automatically upgrade to the lastest Kubernetes patch version
- Automatically upgrade the OS
- Helm Chart upgrades can be applied
- Machines will be hardened

### Requirements

- All cluster machines have to be in a local network
- All cluster machines have to run with Debian 12

### How to use

- Copy the inventory.example file: `cp inventory.example inventory`
- Edit `inventory` to your needs
- Copy the group_vars: `cp -r examples/group_vars groups_vars`
- Edit `group_vars/all/global.yaml` to your needs
