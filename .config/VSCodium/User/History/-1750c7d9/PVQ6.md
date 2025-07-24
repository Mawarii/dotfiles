# ansible-k3s

## Credit
For K3s installation the official [k3s-ansible](https://github.com/k3s-io/k3s-ansible) playbook is imported and must be installed.

## Overview
This Ansible playbook hardens your machines, installs K3s, and deploys default applications:
- Replaces Traefik with Nginx Ingress
- Sets up Cert-Manager for SSL certificates
- Deploys a sample WordPress installation

## Getting Started

### Prerequisites
Ensure your environment meets the following requirements:
- [shell.nix](./shell.nix) is present and configured
- Ansible collections and roles are installed:
```bash
ansible-galaxy install -r requirements.yml
```

### Inventory Setup
1. Copy the example inventory file:
```bash
cp inventory.example inventory
```
2. Customize the inventory file as needed.

### Variables
This playbook uses optional and required variables. Define them in your inventory or variable files.

## Usage
Run the playbook:
```bash
ansible-playbook -i inventory site.yaml
```
