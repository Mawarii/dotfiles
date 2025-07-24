hcloud_token="52cI8VEBNmKxplYK3nswAt7VPcDeBzWzaWr5CGCX804ffL12WNGPoyG18fmUzZZ7"
hetznerdns_token="1BG4eaJ0EKG8ib8M6GAzj6F4qdubHmyS"
cluster_name="pre-stage"
domain_cluster="cluster.pre-stage.wspdev.de"
domain_project="pre-stage.wspdev.de"

# -- Bcrypt hashed admin password
## Argo expects the password in the secret to be bcrypt hashed. You can create this hash with
## `htpasswd -nbBC 10 "" $ARGO_PWD | tr -d ':\n' | sed 's/$2y/$2a/'`
# argocd_admin_password="RjUp3egS5HjfQvf6kTXS5b78QxiR5w4LGJs9x4bBVw9Zmweu"
argocd_admin_password="$2a$10$qLOeZxWjoYHvMi1Zd8LTpeZEjPQ8b5aZPXhVER.rxGbWTdrCyx07G%"

rancher_bootstrap_password="RgL8J8BYwuaEyEs72FNMYkupiBSCeETKVGCf84qEPEcenWGL"
rancher_admin_password="xfmeuBtA7S4Q49AKSNiS9YC2nDRYQT5H"

# gitlab_agent_token="cJgMsyR2Ny5FdhsGRwpCcWaXHhkCjB1B-mEFgTBkeKVjHW4X1g"
gitlab_agent_token="dsfjkghdeofghsdeäpog"