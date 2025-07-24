# Documentation for `docker`-installation [formsflow.ai](https://formsflow.ai) in FMTH

## General overview

[Formsflow.ai](https://formsflow.ai) is an open source low code platform.

The toolset allows you to create business applications flows, processes and forms based on defined rulesets.
Rights and permissions are configured in the intregrated identity management framework.

Below you find general expectations or prequesites being able to deploy [Formsflow.ai](https://formsflow.ai) containerized. #! change

## Environment

### Resources

Based on our experience and following the [Formsflow.ai Installation Documentation](https://aot-technologies.github.io/forms-flow-installation-doc/)
we recommend to install [Formsflow.ai](https://formsflow.ai) in an environment with #! irgendwie mindestanforderung erwähnen

- 64Bit CPU #! add core number
- 16GB Memory (minimum)
- +25GB DISK

Accordingly to the load of the plattform the ressources can be less (e.g. testing purpose only or PoC) or more
(e.g. depending on user or count respectively size of forms).

!!! **NOTE**

    It is possible to summarize split databasetables spread over separated Datebases from initial installation setup
    based on their type into e.g. one.

### Connection

Generally it is necessary to have the permission to connect to the target environment and
having the rights to install, setup and configure the environment.

Because of the code is available public the target-environment should be able to connect to the Internet.
The Setup for internet connection is provider specific or depends on the network of your environment.

Is it impossible to pull the code and/or images directly from internet because of the environment is setup
in intranet, we recommend you provide your own registry and repository where the code and images are available
from server.

The challenge is as soon as you want to apply individual changes from service provider, one have to ensure
code and images are available from environment as well.

Additional you need to ensure, that user are finally able to access the domains of the application as soon as
the installation is done.

### List of repository and registry


* [formsflow.ai Repository](https://github.com/AOT-Technologies/forms-flow-ai) (for single-server-setup)
* [formsflow.ai Helmchart-Repository](https://github.com/AOT-Technologies/forms-flow-ai-charts)
(for managed containerized environments)
* [formsflow.ai Images](https://hub.docker.com/search?q=formsflow) (used for both environments)


### Containerized Deployment (Single-Server)

Being able to install [Formsflow.ai](https://formsflow.ai) on a single-server-setup one should have installed

* e.g. [`docker`](https://www.docker.com/)
* or [`podman`](https://podman.io/)
  
Additional it is required to install

* e.g. `docker-compose`
* `git`

which allows you to pull and maintain the code from the repositories defined in ["List of repository and registry"-Section](#list-of-repository-and-registry).

## Cloud-Deployment.

To deploy [Formsflow.ai](https://formsflow.ai) in the cloud (e.g. [Kubernetes](https://kubernetes.io/) or [Openshift](https://docs.openshift.com/)) you should have
installed

* `helm`
* `git`

which allows you to pull and maintain the code from the repositories defined in ["List of repository and registry"-Section](#list-of-repository-and-registry).

## Special Cases

As soon as formsflow.ai is installing it sometimes might load data from internet during settting the containers. In that case you have to use the opportunity to load the necessary files from a separated container which includes all the required files. We call this container "Micro-Frontend-Container".

## Specific setup for FMTH

### Server (owned by [PD](https://www.pd-g.de/))

#### Resources

* Intel Xenon 64bit
* 4 Core CPU
* 64GB RAM Memory
* DISKS
  * 280GB OS (Raid)
  * 1.1 TB Main-Storage (Raid)
  * 4x 1.1 TB Storage
* 10Gbit LAN


#### Operation System and Tools

(initial from setup)

* `Debian`
* `Docker`
* `Git`

!!! **NOTE**

    As of now there are no further security tools configured, because of the server is not available from internet
    and located in intranet from Provider only.

#### Networksettings

1. Define Network the Server is connected to shared from provider:

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

2. Define proxy to allow connection to internet via proxy shared from provider
   
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

Generally it has to be ensured, the server is available from Users via Browser and Operation-Teammember so it can be maintained and configured.

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