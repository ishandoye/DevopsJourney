# Openstack Flex Terraform

A collection of Terraform examples, reusable modules, and best practices for automating ** OpenStack Flex**.

## Objectives

This repository is intended to provide a structured learning path and reusable code for managing  Flex using Terraform.

The repository starts with read-only examples that safely query existing infrastructure and gradually progresses to provisioning and lifecycle management of OpenStack resources.

## Learning Path
--> https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs

| Step | Description                       |
| ---- | --------------------------------- |
| 01   | Read existing OpenStack resources |
| 02   | Create Networks                   |
| 03   | Create Virtual Machines           |
| 04   | Security Groups                   |
| 05   | Volumes                           |
| 06   | Floating IPs                      |
| 07   | Remote State                      |
| 08   | Modules                           |
| 09   | Production Deployment             |

Each example is independent and can be executed without relying on previous examples.

## Prerequisites

* Terraform
* OpenStack CLI
* Existing  Flex account
* Valid `clouds.yaml`
* Application Credentials

## Authentication

Authentication is performed using the existing OpenStack `clouds.yaml` configuration.

Terraform references the cloud by name:

```hcl
provider "openstack" {
    cloud = "openstack-flex"
}
```

No credentials are stored in this repository.

## Security

Do not commit:

* `terraform.tfstate`
* `.terraform/`
* `terraform.tfvars`
* `clouds.yaml`
* Any credentials or secrets

## Goal

By the end of this repository, you should be able to automate common  Flex operations using Terraform while following infrastructure-as-code best practices.

```
openstack-flex-terraform/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── docs/
│   ├── setup.md
│   ├── authentication.md
│   ├── project-structure.md
│   └── troubleshooting.md
│
├── Project/
│   ├── 01-provider-authentication/
│   ├── 02-read-existing-resources/
│   ├── 03-create-network/
│   ├── 04-create-security-group/
│   ├── 05-create-router/
│   ├── 06-create-instance/
│   ├── 07-create-volume/
│   ├── 08-attach-volume/
│   ├── 09-floating-ip/
│   ├── 10-import-existing-resources/
│   └── 11-destroy-resources/
│
├── modules/
│   ├── network/
│   ├── compute/
│   ├── security-group/
│   └── volume/
│
└── scripts/
```

## NOTE 

- These are executed before running terrafrom init thus some files will not be listed so must run init and plan.

```
.terraform/
.terraform.lock.hcl
```
