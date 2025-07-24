# Ansible Deployment

This project is an Ansible script to deploy forms-flow-ai fully automated with docker on a vm.


## Usage

The only file you have to edit is the inventory file. If you want to use different images have a look at `group_vars/all/glocal.yaml`.

If everything is setup just run this command: `ansible-playbook -i inventory deploy-forms-flow.yaml`

Thats it! After ~30 min. you should have a running forms-flow and Keycloak instance.
