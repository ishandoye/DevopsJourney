## Ansible Ad-hoc Commands
These are one-liners you run directly in the terminal
- Used for quick, simple tasks
- No need to write a file
Example:
```Bash
ansible all -m ping
ansible webservers -m service -a "name=nginx state=restart"
ansible -i inventory all -m "shell" -a "touch test.txt"
ansible -i inventory webservers -m "shell" -a "touch test.txt"
```
- Best for:
  - Quick checks (ping, uptime)
  - Simple actions (restart service, copy file)
- Limitations:
  - Not reusable
  - Hard to manage complex workflows
  - No built-in structure (no variables, roles, sequencing logic)

## Ansible Playbooks

These are YAML files that define tasks in a structured way.

- Used for complex, repeatable automation
- Example:
```Bash
- hosts: webservers
  become: yes
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present

    - name: Start nginx
      service:
        name: nginx
        state: started
```
- Best for:
  - Multi-step deployments
  - Configuration management
  - Reusable automation (roles, variables, templates)
- Advantages:
  - Version-controlled
  - Readable and organized
  - Supports conditionals, loops, handlers, etc.

## Simple Way to Remember
- Ad-hoc = quick command (like a one-time shell command)
- Playbook = structured automation (like a script/program)

## When to Use What
- Use ad-hoc → when you need to do something fast and simple
- Use playbooks → when the task is important, repeatable, or complex
