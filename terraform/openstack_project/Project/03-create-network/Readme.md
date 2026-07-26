# Example 03 - Create Network

## Objective

Create a private network, subnet and router inside Rackspace OpenStack Flex.

---

## Prerequisites

- Terraform >= 1.5
- Working clouds.yaml
- Existing OpenStack project
- Authentication verified (Example 01)

---

## Resources Created

- Network
- Subnet
- Router
- Router Interface

---

## Files

provider.tf
Provider configuration.

variables.tf
Input variables.

terraform.tfvars.example
Example variable values.

main.tf
Network resources.

outputs.tf
Displays created resource IDs.

---

## Variables

| Variable | Description |
|----------|-------------|
| network_name | Network Name |
| subnet_name | Subnet Name |
| cidr | Subnet CIDR |
| router_name | Router Name |

---

## Run

terraform init

terraform plan

terraform apply

---

## Verify

openstack network list

openstack subnet list

openstack router list

---

## Cleanup

terraform destroy
