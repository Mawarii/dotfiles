# Forms-flow-ai Ansible Deployment

This project is an Ansible script to deploy forms-flow-ai fully automated with Docker. It will also install Docker on your machine if not already installed.

At the end you will have 2 folders on your machine. The caddy (optional) folder for the reverse proxy magic and the formsflow folder.

Tree example:

```
├── caddy (optional)
│   ├── Caddyfile
│   └── compose.yaml
└── formsflow
    ├── analytics
    │   ├── compose.yaml
    │   └── .env
    ├── dataanalysis
    │   ├── compose.yaml
    │   └── .env
    ├── deployment
    │   ├── 001_custom_user.js
    │   ├── compose.yaml
    │   └── .env
    └── keycloak (optional)
        ├── compose.yaml
        ├── .env
        └── imports
            └── formsflow-ai-realm.json
```

## Usage

Copy `inventory.example` and edit it to your needs.

Everything inside `group_vars/all/global.yaml` can be edited but the playbook will run completely without issue if you don't.

Run: `ansible-playbook -i inventory deploy-forms-flow.yaml`

Thats it! After ~30 minutes (depending on your download speed) you should have a running forms-flow-ai instance.

## Notes

- You can run the ansible playbook more than once, but at this state it would just restart the docker containers if they are not running. Passwords and the bpm Keycloak client secret are only generated in the first run. If you want to regenerate them you have to delete the `.env` files.
- Disabling Caddy as reverse proxy will still create the `reverse_proxy` Docker network.
- If you disable the builtin Keycloak depolyment be sure to set the `bpm_clientsecret` variable.
- Redash can not be fully automated, so be sure to visit the URL and set it up. You would also have to edit the `deployment/.env` file to add the Insight API key.
