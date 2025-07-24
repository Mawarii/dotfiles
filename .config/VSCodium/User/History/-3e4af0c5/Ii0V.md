# Forms-flow-ai Ansible Deploy

This project is an Ansible script to install Docker and deploy forms-flow-ai fully automated. It will also install Docker on your machine if not already installed.

Tree example:

```
├── docker
│   ├── caddy (optional)
│   │   ├── Caddyfile
│   │   └── compose.yaml
│   ├── data_analysis (optional)
│   │   ├── compose.yaml
│   │   └── .env
│   ├── forms-flow-ai
│   │   ├── 001_custom_user.js
│   │   ├── compose.yaml
│   │   └── .env
│   ├── keycloak (optional)
│   │   ├── compose.yaml
│   │   ├── .env
│   │   └── imports
│   │       └── formsflow-ai-realm.json
│   └── redash (optional)
│       ├── compose.yaml
│       └── .env
```

## Usage

Copy `inventory.example` and edit it to your needs.

Everything inside `group_vars/all/global.yaml` can be edited but the playbook will run completely without issue if you don't.

Run: `ansible-playbook -i inventory deploy-forms-flow.yaml`

Thats it! After ~30 minutes (depending on your download speed) you should have a running forms-flow-ai instance.

## Notes

- You can run the ansible playbook more than once, but at this state it would just restart the docker containers if they are not running. Passwords and secrets are only generated in the first run. If you want to regenerate them you have to delete the `.env` files.
- Disabling Caddy as reverse proxy will still create the `reverse_proxy` Docker network.
- If you disable the builtin Keycloak depolyment be sure to set the `bpm_clientsecret` variable.
- Redash initial setup is automated. SAML configuration is WIP.
