# Kubernetes Cluster Deployment with Ansible

This Ansible playbook automates the deployment of a Kubernetes cluster on Debian 12, using CRI-O as the container runtime.

## Features

- **Automated Upgrades**
  - Installs the latest Kubernetes patch version
  - Keeps the operating system up to date
- **Helm Integration**
  - Supports seamless application upgrades via Helm Charts
- **Security & Stability**
  - Hardens all cluster machines
  - Fully idempotent for safe re-runs

## Requirements

- All cluster nodes must be in the same local network
- All machines must run Debian 12

## Usage

1. Make sure `python-dateutil` is installed:
    ```sh
    python -m pip install python-dateutil
    ```
  or run the `nix-shell`

2. Set up the inventory:
    ```sh
    cp inventory.example inventory
    ```
    Edit `inventory` to match your cluster setup.

    > Important:
    > The hostnames must be the same as in your cluster!

3. Configure variables:
    ```sh
    cp -r examples/group_vars group_vars
    ```
    Edit `group_vars/all/global.yaml` as needed.

4. Deploy the cluster:
    ```sh
    ansible-playbook -i inventory site.yaml
    ```
