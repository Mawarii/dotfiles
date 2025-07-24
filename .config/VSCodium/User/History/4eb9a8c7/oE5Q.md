---
title: Migration WSP to EfA Cluster
---

### Introduction

This guide will show you how to migrate from the WSP Cluster to the EfA Cluster. It will cover the migration from the Argo CD application and all the deployment files.

### The Argo CD Application

In most cases this is just one file. Within the WSP environment it is stored inside one repostiory per stage under the following path: `/themenwelt-wirtschaft/infrastruktur/cluster/<stage>/apps`

Inside this repository you will find a folder named like your application and inside this folder is your `application.yaml` file.
It should look something like this:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  labels:
    app.kubernetes.io/instance: argo-test
    gitlab.publicplan.cloud/primary-application-project-id: "603"
    gitlab.publicplan.cloud/primary-application-project-release-branch: develop
  name: argo-test
  namespace: argo-cd
spec:
  destination:
    namespace: argo-test
    server: 'https://kubernetes.default.svc'
  project: wsp--wsp-nrw
  source:
    path: applications/argo-test/overlays/develop/
    repoURL: 'git@gitlab.publicplan.cloud:themenwelt-wirtschaft/infrastruktur/common/app-configs.git'
    targetRevision: main
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

You can copy paste this file to the new repository: `iac/efa/applications/<your-application>/<stage>`. Details to the new repository structure can be found [here](/operations/Infrastructure/Clusters/EfA/wsp-migration-guide).

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  labels:
    app.kubernetes.io/instance: argo-test
    gitlab.publicplan.cloud/primary-application-project-id: "603"
    gitlab.publicplan.cloud/primary-application-project-release-branch: develop
  name: argo-test
  namespace: argocd
spec:
  destination:
    namespace: argo-test
    server: 'https://kubernetes.default.svc'
  project: efacluster-argo-test
  source:
    path: kustomization/overlays/develop
    repoURL: 'git@gitlab.publicplan.cloud:iac/efa/distributions/argo-test/argo-test-application.git'
    targetRevision: main
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```
