# iac-monicore-clustermeta-infra-base

# Usage

1. Copy `.env.example` as `.env`, fill in the token and run `source .env` or set the env vars in dot rc file (`.zshrc`, `.bashrc`, etc.)

2. Copy `variables.tfvars.template` as `variables.tfvars` and fill in the Hetzner Cloud token

3. Run `tofu init -upgrade`

4. Run `tofu plan -var-file=variables.tfvars -out monicore`

5. Run `tofu apply monicore`
