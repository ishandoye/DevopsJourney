## 1. Architecture

**Ansible** -> Agentless (Push model)
- No agent installed on servers
- Uses SSH to push configs directly

**Puppet & Chef** -> Agent-based (Pull model)
- Agent runs on each node
- Nodes pull configs from master periodically

***One Liner*** -> "Ansible is agentless & push-based, while Puppet and Chef are agent-based & pull-based."

## 2. Configuration Language
- Ansible -> YAML (very easy, human-readable)
- Chef -> Ruby DSL (needs coding knowledge)
- Puppet -> Puppet DSL (declarative, but less intuitive)

## 3. Setup & Installation
- Ansible -> Very simple (install only on control node)
- Chef -> Complex (Server + Workstation + Client)
- Puppet -> Moderate (Master + Agents + certificates)

## 4. Speed & Real-time changes
- Ansible -> Immediate (push instantly)
- Puppet/Chef -> Delay (agents check periodically)

***One Liner*** -> "Ansible is better for real-time changes."
