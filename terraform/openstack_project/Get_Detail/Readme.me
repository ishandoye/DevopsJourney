# Openstack Flex Terraform Read-Only Test

This repository is a **read-only Terraform test project** for OpenStack Flex.

The purpose is to confirm that Terraform can authenticate through an existing `clouds.yaml` entry and read data from the OpenStack environment without creating, updating, or deleting anything.

## What this project does

* Uses the existing `clouds.yaml` configuration already working with the OpenStack CLI
* Connects to the Openstack Flex environment using the OpenStack Terraform provider
* Reads existing OpenStack objects with `data` sources only
* Does not create infrastructure

## Prerequisites

* Terraform installed
* Existing working `~/.config/openstack/clouds.yaml`
* A valid cloud name defined in `clouds.yaml`
* Access to the target Openstack Flex environment

## Project files

```text
provider.tf
variables.tf
terraform.tfvars
main.tf
README.md
.gitignore
```

## How it works

The OpenStack provider supports using a named cloud from `clouds.yaml`, so the provider block only needs the cloud name. Terraform data sources are read-only and are used here only to verify that Terraform can query the environment.

## Example flow

1. Confirm the OpenStack CLI works with the existing `clouds.yaml`
2. Set the cloud name in `terraform.tfvars`
3. Run `terraform init`
4. Run `terraform plan`
5. Review the read-only values returned by the data sources

## Example `terraform.tfvars`

```hcl
cloud_name   = "openstack-flex"
server_id    = "4873f469-7da5-4a32-9b09-c585ac34bdd0"
network_name = "Ishan"
image_name   = "AlmaLinux 8"
flavor_name  = "gp.0.2.6"
```

## What to keep out of Git

Do not commit:

* `terraform.tfstate`
* `terraform.tfstate.backup`
* `.terraform/`
* any secret files
* any local override files containing credentials

## Example `.gitignore`

```gitignore
.terraform/
*.tfstate
*.tfstate.backup
*.tfvars
override.tf
override.tf.json
*_override.tf
*_override.tf.json
```

If you need to keep a non-secret `terraform.tfvars` example in Git, use a separate file such as `terraform.tfvars.example` instead.

## Run

```bash
terraform init
terraform plan
```

## Expected result

A successful plan shows that Terraform can connect to the Openstack Flex environment and read the requested OpenStack data without making changes.

