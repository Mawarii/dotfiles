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

| **Required Variables**            | **Default Value**      |
|-----------------------------------|------------------------|
| k3s_version                       | v1.32.3+k3s1           |
| extra_server_args                 | --disable=traefik      |
| ssh_keys                          | your, ssh, keys        |

| **Optional Variables**            | **Default Value**                 |
|-----------------------------------|-----------------------------------|
| kubeconfig                        | ~/.kube/config.new                |
| ssh_user                          | debian                            |
| ssh_port                          | 22222                             |
| cert_manager.chart_version        | v1.17.1                           |
| cert_manager.namespace            | cert-manager                      |
| letsencrypt.mail                  | void@mawari.eu                    |
| ingress_nginx.chart_version       | 4.12.1                            |
| ingress_nginx.namespace           | ingress-nginx                     |
| wordpress.chart_version           | 24.1.18                           |
| wordpress.namespace               | wordpress                         |

## Usage
Run the playbook:
```bash
ansible-playbook -i inventory site.yaml
```
