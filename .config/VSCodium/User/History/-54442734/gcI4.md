# Aufbau

Preamble:

- **Bold** = repository | not bold = group

- Infrastructure as Code (*inaccessible*)
    - EfA
        - applications
            - edap (in progress)
            - Empfangsclient
                - **develop (publicplan)**
                - **pre-stage (publicplan)**
                - **staging (OWL-IT)**
                - **production (OWL-IT)**
            - Intermedi&auml;re Plattform
        - cluster-meta
            - develop (publicplan)
                - infrastructure
                    - **applications**
                    - **cluster-base**
                    - **distributions**
            - pre-stage (publicplan)
                - infrastructure
                    - **applications**
                    - **cluster-base**
                    - **distributions**
            - staging (OWL-IT) (incoming / structured like pp-clusters)
                - infrastructure
                    - **applications**
                    - **distributions**
            - production (OWL-IT) (incoming / structured like pp-clusters)
                - infrastructure
                    - **applications**
                    - **distributions**
            - **cluster-dependencies** (optional / Basis des Terraform-Skripts)
        - distributions
            - EDelivery Access Point (pending)
            - Empfangsclient
                - **EC**
            - Intermediäre Plattform (pending)

# Allgemeine Infos

Die Ordner-Struktur verfolgt einen Aufbau, wo jedes Repository mit dem Namen "applications" sämtliche Files für ArgoCD enthält. Repositories mit dem Namen "distributions" liefern die tatsächliche Konfiguration (e. g. kustomizations,Helm-values-files und gegebenenfalls noch ressourcen, die darüber hinaus gebraucht werden). Repositories dieser art in einem instratructure subfolder liefern die Cluster-Level Applikationen, wie den Prometheus Operator oder den [Cloudnative-PG](https://cloudnative-pg.io/)

distributions/applications-gruppen direkt unter EfA verfolgen einen &auml;hnlichen Aufbau, sind allerdings noch einmal in weitere Projektgruppen aufgeteilt in denen dann die entsprechenden Repositories zu finden sind (name der obergruppe gibt hier analog zur Infrastruktur den Zweck des Repositories an).

## Secret Replication

- im Namespace kubernetes-replicator liegt ein gleichnamiges Deployment (Konfiguration unter cluster-meta/&lt;cluster-stage&gt;/infrastructure/distributions &rarr; applications/kubernetes-replicator)

## repository URLs, die Geklont werden müssen:

Cluster-Aufbau:

- Staging
    - Argo-Files: https://gitlab.publicplan.cloud/iac/efa/cluster-meta/staging/infrastructure/applications.git
    - Distributions: https://gitlab.publicplan.cloud/iac/efa/cluster-meta/staging/infrastructure/distributions.git
- Production
    - Argo-Files: https://gitlab.publicplan.cloud/iac/efa/cluster-meta/staging/infrastructure/applications.git
    - Distributions: https://gitlab.publicplan.cloud/iac/efa/cluster-meta/staging/infrastructure/distributions.git

Empfangsclient:

- Distributions:  
    https://gitlab.publicplan.cloud/iac/efa/distributions/empfangsclient/ec.git
- Staging Argo-Files:  
    https://gitlab.publicplan.cloud/iac/efa/applications/empfangsclient/staging.git
- Production Argo-Files:  
    https://gitlab.publicplan.cloud/iac/efa/applications/empfangsclient/production.git
