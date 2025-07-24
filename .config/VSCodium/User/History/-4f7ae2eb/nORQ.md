# Ansible Deployment

This project is an Ansible script to deploy forms-flow-ai fully automated with docker.

At the and you will have 2 folders on your machine. The caddy folder for the reverse proxy magic (optional) and the formsflow folder.

Tree example:

```
├── caddy
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
    └── keycloak
        ├── compose.yaml
        ├── .env
        └── imports
            └── formsflow-ai-realm.json
```

## Usage

The only file you have to edit is the inventory file. If you want to use different images have a look at `group_vars/all/glocal.yaml`.

If everything is setup just run this command: `ansible-playbook -i inventory deploy-forms-flow.yaml`

Thats it! After ~30 min. you should have a running forms-flow and Keycloak instance.

## Notes

- You can run the ansible playbook more than once, but at this state it would just restart the docker containers if they are not running. Passwords and the bpm client secret are only generated/pulled in the first run. If you want to regenerate them you have to delete the .env files.

- If you disable the Caddy installation the `caddy_proxy` Docker network is still created. So we don't have to add different compose files. And if you want to use a different reverse proxy inside a Docker container you can use this network nevertheless.
