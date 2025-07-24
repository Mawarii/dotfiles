# EfA Cluster Pre-Stage Infrastructure

This repository contains all the infrastructure code for the Pre-Stage EfA Cluster.

### Usage

1. Run `cp variables.tfvars.template variables.tfvars`

2. Get the Hetzner Cloud Token as described in the `variables.tfvars.template` file

3. ```bash
    tofu init \
    -backend-config="username=your-username" \
    -backend-config="password=$GITLAB_ACCESS_TOKEN"
    ```
    `username` should be your gitlab username and `password` is a personal access token with api access.

4. Run `tofu plan -var-file=variables.tfvars -out efacluster`

5. Run `tofu apply efacluster`
