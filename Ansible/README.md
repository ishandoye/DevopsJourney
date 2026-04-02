## Ansible Documentation.
[Ansible Doc](https://docs.ansible.com/projects/ansible/latest/getting_started/index.html)
[Ansible Module](https://docs.ansible.com/projects/ansible/2.9/modules/list_of_all_modules.html#all-modules)

---

## 1. Control Node Requirements
- Linux machine (preferred: Ubuntu / EL / Amazon Linux)
- Python installed (Ansible depends on Python)
- Ansible installed

## 2. Target Nodes Requirements
- SSH access enabled
- Python installed (Ansible modules run using Python on remote machines)
- Accessible from the control node (network connectivity)

## 3. SSH Setup (Core requirement)
- SSH key pair (recommended over password)
```Bash
ssh-keygen
```
- Public key copied to all target servers
```Bash
ssh-copy-id
```
## 4. Network & Connectivity
- Control node can reach target nodes (ping/SSH)
- Port 22 (SSH) is open in security groups
- No firewall is blocking the connection

## 5. Inventory Planning
- Which servers are you managing
- Grouping (web, db, app)
```Ansible
webservers -> nginx
dbservers -> mysql
```

## 6. Package Manager Access
- Have internet access OR
- Access to internal repo (for installing packages)

## 7. Sudo / Privilege Access
- User has sudo privileges
- Passwordless sudo is preferred

## 8. Time Sync & Basic OS Readiness
- System time synced (NTP)
- Proper hostname setup
- Clean OS (no broken packages)

## 9. Interview Answer
- Ansible requires a control node with Ansible installed and target nodes with SSH access and Python installed.
- We also need proper SSH key setup, network connectivity between control and managed nodes, sudo privileges on target systems, and an inventory defining the servers.
- In cloud environments like AWS, security groups and key pairs must also be configured.

## 10. Most Failure
- SSH issues
- Missing Python
- Permission problems
