# ansible-k3s

## Credit
For the K3s installation the official [k3s-ansible](https://github.com/k3s-io/k3s-ansible) playbook is imported.

```bash
ansible-galaxy install -r collections/requirements.yaml
```

## Overview
This Ansible playbook hardens your machines, installs K3s, and deploys default applications:
- Replaces Traefik with Nginx Ingress
- Sets up Cert-Manager for SSL certificates
- Deploys a sample WordPress installation

## Getting Started

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
