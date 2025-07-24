# EfA Cluster Pre-Stage Infrastructure

This repository contains all the infrastructure code for the Pre-Stage EfA Cluster.

### Requirements



### Usage

1. `cp variables.tfvars.template variables.tfvars`

2. Get the Hetzner Cloud Token as described in the `.tfvars` file

3. Run `tofu plan -var-file=variables.tfvars -out efacluster`

4. Run `tofu apply efacluster`
