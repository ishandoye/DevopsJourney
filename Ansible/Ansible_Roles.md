## What are Ansible Roles?
- Ansible roles are a way to organize automation content (tasks, variables, files, templates, handlers) into a standard directory structure.
- Instead of writing everything in one long playbook, roles let you split things into reusable, structured components.

## Why were Roles introduced?
1. Messy playbooks</br>
   Large playbooks became hard to read and maintain.
   
2. Lack of reuse</br>
   People were copying the same tasks across multiple playbooks.

3. No standard structure</br>
   Different teams organized the Ansible code differently, which is confusing.

## Why use Roles?
***Use roles when you want:***
| Benefit | Description |
| :--- | :--- |
| ***Reusability*** | Write once, use in many playbooks |
| ***Clean structure*** | Separate tasks, variables, templates, etc. |
| ***Team collaboration*** | Everyone follows the same layout |
| ***Scalability*** | Works better as automation grows |
> [!TIP]
> ***Instead of writing Nginx setup in every playbook → create a nginx role and reuse it.***

## When to use Roles?
***Use roles when:***

- Your playbook is getting large or complex
- You repeat the same configuration across systems
- You want to share code across teams or projects
- You are building production-level automation

***Avoid roles when:***

- You are writing a small one-time task
- Very simple playbooks

## How Roles work (Structure)
***A role has a fixed directory structure like this:***
```
roles/
  nginx/
    tasks/
      main.yml
    handlers/
      main.yml
    templates/
    files/
    vars/
      main.yml
    defaults/
      main.yml
    meta/
      main.yml
```
### Key parts:

| Directory | Description |
| :--- | :--- |
| ***tasks/*** | main work (what to execute) |
| ***handlers/*** | triggered actions (like restart service) |
| ***templates/*** | Jinja2 templates |
| ***files/*** | static files |
| ***vars/*** | variables (higher priority) |
| ***defaults/*** | default variables (lower priority)|
| ***meta/***| role dependencies|

## How to use Roles
### 1. Create Role
```Bash
ansible-galaxy init nginx
```
### 2. Define tasks
Example: ``roles/nginx/tasks/main.yml``
```YAML
- name: Install nginx
  apt:
    name: nginx
    state: present

- name: Start nginx
  service:
    name: nginx
    state: started
```

### 3. Use role in a playbook
```YAML
- hosts: web
  roles:
    - nginx
```
### 4. Optional: Pass variables
```YAML
- hosts: web
  roles:
    - role: nginx
      vars:
        port: 80
```

## Summary

| Question | Description |
| :--- | :--- |
| ***What*** | Roles = structured, reusable Ansible components |
| ***Why introduced*** | To fix messy, non-reusable playbooks |
| ***Why use*** | Clean code, reuse, scalability |
| ***When to use*** | Large, repeatable, production automation |
| ***How to use*** |Create role → define tasks → call in playbook|
