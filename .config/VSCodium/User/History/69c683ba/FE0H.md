# Documentation for `docker`-installation [formsflow.ai](https://formsflow.ai) in FMTH

## General overview

[Formsflow.ai](https://formsflow.ai) is an open source low code platform.

The toolset allows you to create business applications flows, processes and forms based on defined rulesets.
Rights and permissions are configured in the intregrated identity management framework.

Below you will find general expectations or requirements for the deployment of a containerized [Formsflow.ai] (https://formsflow.ai) instance.

## Environment

### Resources

Based on our experience and following the [Formsflow.ai Installation Documentation](https://aot-technologies.github.io/forms-flow-installation-doc/)
we recommend these minimum requirements:

- 64Bit CPU 4 Cores
- 16GB Memory
- 25GB Disk Space

Accordingly to the load of the plattform the ressources can be less (e.g. testing purpose only or PoC) or more
(e.g. depending on user or count respectively size of forms).

!!! **NOTE**

    If you have limited resources, you can combine all PostgreSQL instances into one to save some computing power.

### Connection

Generally it is necessary to be able to connect to the target environment and
having the permissions to install, setup and configure the environment.

Because the code is publicly available the target environment should be able to access the internet.

This specific environment is an intranet setup and we recommend you provide your own registry and repository
where the code and images are served.

The challenge is as soon as you want to apply individual changes from service providers, one have to ensure
code and images are available from the environment as well.

Additional you need to ensure that users are finally able to access the domains of the application as soon as
the installation is done.

### List of repository and registry

* [formsflow.ai Repository](https://github.com/AOT-Technologies/forms-flow-ai) (for single server setup)
* [formsflow.ai Helmchart-Repository](https://github.com/AOT-Technologies/forms-flow-ai-charts)
(for managed containerized environments)
* [formsflow.ai Images](https://hub.docker.com/search?q=formsflow) (used for both environments)

### Containerized Deployment (Single Server)

Being able to install [Formsflow.ai](https://formsflow.ai) on a single server setup one should have installed

* e.g. [`docker`](https://www.docker.com/)
* or [`podman`](https://podman.io/)
  
Additional it is required to install

* e.g. `docker-compose`
* `git`

which allows you to pull and maintain the code from the repositories defined in the ["List of repository and registry"](#list-of-repository-and-registry) section.

## Cloud Deployment.

To deploy [Formsflow.ai](https://formsflow.ai) in the cloud (e.g. [Kubernetes](https://kubernetes.io/) or [Openshift](https://docs.openshift.com/)) you'll need:

* `helm`
* `git`

which allows you to pull and maintain the code from the repositories defined in the ["List of repository and registry"](#list-of-repository-and-registry) section.

## Special Cases

As soon as formsflow.ai is installing it sometimes might load data from the internet. In that case you have to use the opportunity to load the necessary files from a separated container which includes all the required files. We call it the "Micro-Frontend" container.

## Specific setup for FMTH

### Server (owned by [PD](https://www.pd-g.de/))

#### Resources

* Intel Xenon 64bit 4 Core CPU
* 64GB RAM
* Disks
  * 280GB OS (Raid)
  * 1.1 TB Main-Storage (Raid)
  * 4x 1.1 TB Storage
* 10 Gbit LAN

#### Operation System and Tools

(initial from setup)

* `Debian`
* `Docker`
* `Git`

!!! **NOTE**

    As of now there are no further security tools configured, because the server has no internet access
    and is located in an intranet from the provider.

#### Networksettings

1. Provider specific network settings:

   `$ cat /etc/network/interfaces`

    ```shell
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    source /etc/network/interfaces.d/*
    # The loopback network interface
    auto lo
    iface lo inet loopback

    # The primary network interface
    #allow-hotplug eno1 #iface eno1 inet dhop allow-hotplug eno1
    auto eno1
    iface eno1 inet static
        address 10.54.142.11/27
        gateway 10.54.142.30
    ```

2. Provider specific proxy settings:
   
   `$ cat /etc/profile.d/proxy.sh`

    ```shell
    formsflow@pd-pp-formsflow-001;~$ cat /etc/profile.d/proxy.sh ## set proxy config via profile.d - should apply for all users ## http/https/ftp/no_proxy
    #
    export http_proxy="http://10.19.241.1:8088/" export https_proxy="http://10.19.241.1:8088/"
    #export ftp_proxy-"http://10.19.241.1:8088/*
    export no_proxy="127.0.0.1, localhost" ## curl
    #
    export HTTP PROXY="http://10.19.241.1:8088/" export HTTPS PROXY="http://10.19.241.1:8088/"
    #export FTP PROXY="http://10.19.241.1:8088/"
    export NO_PROXY="127.0.0.1, localhost"
    ```

### Provider related configuration

Generally it has to be ensured that the server applications can be accessed via browser and Operation-Teammember so it can be maintained and configured.

#### Ports

##### CLI-Connection

This ensures you are able to connect to the server. We configured the server with the default ssh-port:

| Source | Destination | Ports |
| --- | --- | --- |
| 10.63.4.5 (JumpHost) | 10.54.142.11 (pd-pp-formsflow-001) | 22, 1337 |

##### Browser-Connection

To make it possible the endpoints/urls are finally available from browser you have to allow Ports you can 
connect to the server from intranet:

| Source | Destination | Ports |
| --- | --- | --- |
| 10.63.4.5 (JumpHost), Intranet | 10.54.142.11 (pd-pp-formsflow-001) | 443, 80 |

##### LDAP-Connection

This allows the communication between the to be connected LDAP and setup [Formsflow.ai](https://formsflow.ai)-server.

| Source | Destination | Ports |
| --- | --- | --- |
| 10.54.142.11 (pd-pp-formsflow-001) | 10.63.0.1 (LDAP) | 3268, 3269 |


#### Domain(s)

To ensure Formsflow can be accessed via Browser you need to provide Domains and Certificates.
We recommend to assign an wildcard-certificate including a wildcard-domain to the server,
the application installation can be maintained from `nginx` or `caddy`.

##### Domain-Lists

| Name | Domain |
| --- | --- |
| Wildcard | *.thlvhlc1.zv.thlv.de |
| Web-Login | forms-flow-web.thlvhlc1.zv.thlv.de |
| form.io | forms-flow-forms.thlvhlc1.zv.thlv.de |
| Camunda | forms-flow-bpm.thlvhlc1.zv.thlv.de |
| Redash | forms-flow-analytics.thlvhlc1.zv.thlv.de |
| Keycloak | forms-flow-idm-keycloak.thlvhlc1.zv.thlv.de |
| Web-API | forms-flow-api.thlvhlc1.zv.thlv.de |
| Documents-API | forms-flow-documents-api.thlvhlc1.zv.thlv.de |
| Data-Analysis | forms-flow-data-analysis-api.thlvhlc1.zv.thlv.de |
| Microfrontend | forms-flow-micro-frontend.thlvhlc1.zv.thlv.de |


#### LDAP Configuration

The Configuation of the LDAP itself inside the identity management tool (Keycloak), has to be as follows:

| Name | Value |
| --- | --- |
| Connection URL | ldaps://thlvzvdc01.zv.thlv.de:3269 (SSL) / ldap://thlvzvdc01.zv.thlv.de:3268 |
| Bind DN | CN=LDAP Formsflow,OU=Benutzer,DC=zv,DC=thlv,DC=de |
| Bind type | simple |
| Bind credentials | ************* |
| Users DN | DC=thlv,DC=de |
| Username LDAP attribute | userPrincipalName |
| UUID LDAP aiitribute | objectGUID |
| user object classes | user |
| User LDAP filter | (memberOf:1.2.840.113556.1.4.1941:=CN=THLV-Formsflow,OU=Gruppen,DC=zv,DC=thlv,DC=de) |
| Search scope | Subtree | 


#### LDAP Mapping

Here you connect the preset attributes to the related LDAP-attributes to ensure,
the correct values are properly transfered to the identity management tool.

| Mapper name | User Model Attribute | LDAP Attribute |
| --- | --- | --- |
| email | email | mail |
| first name | firstName | givenName |
| last name | lastName | sn |
| username | username | userPrincipalName |

## References

* [Formsflow.ai Documentation](https://formsflow.ai)
* [Formsflow.ai Installation Documentation](https://aot-technologies.github.io/forms-flow-installation-doc/)