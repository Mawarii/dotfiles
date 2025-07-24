## Cluster Configuration

This Ansible script deploys a Kubernetes cluster with a Debian 12 base and CRI-O as container runtime.

### Features

- Automatically upgrade to the lastest Kubernetes patch version
- Automatically upgrade the OS
- Helm Chart upgrades can be applied
- Machines will be hardened
- Idempotent

### Requirements

- All cluster machines have to be in a local network
- All cluster machines have to run Debian 12

### Usage

1. Copy the inventory.example file: `cp inventory.example inventory`
2. Edit `inventory` to your needs
3. Copy the group_vars: `cp -r examples/group_vars groups_vars`
4. Edit `group_vars/all/global.yaml` to your needs
5. Run the script: `ansible-playbook -i inventory site.yaml`
