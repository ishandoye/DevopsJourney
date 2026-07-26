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

```
$ terraform init
Initializing the backend...

Initializing provider plugins...
- Finding terraform-provider-openstack/openstack versions matching "~> 3.0"...
- Installing terraform-provider-openstack/openstack v3.4.0...
- Installed terraform-provider-openstack/openstack v3.4.0 (self-signed, key ID 4F80527A391BEFD2)
Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://developer.hashicorp.com/terraform/cli/plugins/signing

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
