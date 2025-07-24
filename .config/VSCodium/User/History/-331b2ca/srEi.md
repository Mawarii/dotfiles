# iac-monicore-clustermeta-infra-base

## Usage

1. Copy `.env.example` to `.env`, fill in your token, and run `source .env` — or add the environment variables to your shell config file (e.g. `.zshrc`, `.bashrc`, etc.).

2. Copy `variables.tfvars.template` to `variables.tfvars` and insert your Hetzner Cloud token.

3. Run `tofu init -upgrade` to initialize the project.

4. Run `tofu plan -var-file=variables.tfvars -out monicore` to generate the execution plan.

5. Run `tofu apply monicore` to apply the changes.
