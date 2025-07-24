# nextcloud-vo_federation-dist

This repository contains the Kubernetes configuration files for deploying the VO Federation app in a federated Nextcloud testing environment.

The Nextcloud container image is based on https://github.com/juliusknorr/nextcloud-docker-dev and customized to include the VO Federation app and patched with oustanding Nextcloud core PRs.

* https://gitlab.publicplan.cloud/themenwelt-kommunales/nextcloud-server
* https://nextcloud-vo-federation.readthedocs.io/en/latest/
* https://github.com/nextcloud/vo_federation

## TODO

* Persistent Storage
* letsencrypt voapp subdomain `*.voapp.dev.publicplan.cloud`
