> [!IMPORTANT]
> - The extension of the file  will be ".yml or .yaml."
> - Indentation is the key to avoiding most of the errors.
- ## Let's jump to the YAML file  explanation.

- ### These three hyphens indicate that it is Yaml file.
```YAML
---
```

### Now start explaining your Playbook
#### Name of your playbook or what is the task of it.
> [!NOTE]
```YAML
- name: Install and start nginx  
  hosts: all  ## Mention your hosts like how you group them like webserver/db and all for all the devices from any group.
  become: root  ## mention Which user should run it, if root the user will become root that is sudo and then will execute.
## Now start writing your tasks
  tasks:
    



