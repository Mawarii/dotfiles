---
title: EfA-Cluster - Repository Structure
---

In accordance to a new system specifically created for a more granular permission management, a new group has been created called Infrastructure as Code. This is where the EfA-Cluster's GitOps-Resources as well as terraform scripts can be retrieved from.

# Allgemeine Infos

Any Group within the cluster's subgroup follows a few general rules:

1. Every repository with the name "applications" or an equally named parent subgroup MUST contain the application's ArgoCD specific files, e. g. any ArgoCD-Application file and dependending on the repository's purpose any corresponding AppProjects.
2. Every repository with the name "distributions" or an equally named parent subgroup MUST contain files, used by any Application file.
3. Any repository or subgroup that starts with the prefix "cluster-" MUST ONLY be used for files that specifically target a cluster's setup. Example for those are primarily terraform scripts (Repositories named cluster-base) and their modules (Repository named cluster-dependencies)
4. Any Application that is crucial for the Cluster's functionality SHOULD be deployed using either Terraform, Ansible or any comparable or compatible tool.
5. Any Application that is not crucial for the Cluster's functionality SHOULD be deployed via ArgoCD.

## Legend

- **Bold** = Repository | not bold = (sub)group
- Name (optional note) / \[url parameter, if it differs\]

## Structure

- Infrastructure as Code / iac
    - EfA / efa
        - applications
            - EDelivery Access Point / edap
            - Empfangsclient / empfangsclient
                - **develop (publicplan)**
                - **pre-stage (publicplan)**
                - **staging (OWL-IT)**
                - **production (OWL-IT)**
            - Intermedi&auml;re Plattform / intermediaryplatform
        - cluster-meta
            - develop (Hetzner Cloud / managed by publicplan)
                - infrastructure
                    - **applications**
                    - **cluster-base**
                    - **distributions**
            - pre-stage (Hetzner Cloud / managed by publicplan)
                - infrastructure
                    - **applications**
                    - **cluster-base**
                    - **distributions**
            - staging (Hetzner Cloud / managed by OWL-IT and publicplan)
                - infrastructure
                    - **applications**
                    - **distributions**
            - **cluster-dependencies**
        - distributions
            - EDelivery Access Point / edap
            - Empfangsclient / empfangsclient
                - **EC** / ec
            - Intermediäre Plattform / intermediaryplatform