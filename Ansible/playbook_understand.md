- The extension of the file  will be ".yml or .yaml."
```Yaml
--- # These three hyphens indicate that it is Yaml file.
## Now start explaining your Playbook
- name: Install and start nginx  ## Name of your playbook or what is the task of it.
  hosts: all  ## Mention your hosts like how you group them like webserver/db and all for all the devices from any group.
  become: root  ## mention Which user should run it, if root the user will become root that is sudo and then will execute.
## Now start writing your tasks
  tasks:
    



