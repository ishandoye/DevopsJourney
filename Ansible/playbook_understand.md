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

```YAML
---
- name: Install and start nginx
```
#### Please mention your hosts, depending on how you group them, like webservers/dbservers and all for all the devices from any group.
```YAML
---
- name: Install and start nginx
  hosts: all
```
#### Please mention which user should run it. If root, the user will become sudo root and then will execute.
```YAML
---
- name: Install and start nginx
  hosts: all
  become: root
```
#### Now start writing your tasks by giving some other commands, like a name for naming what the use of it is.
```YAML
---
- name: Install and start nginx
  hosts: all
  become: root

  tasks:
   - name: Install nginx
```
#### Either you can use Shell for the installation or the other way around, as described right next to it. 
```YAML
---
- name: Install and start nginx
  hosts: all
  become: root

  tasks:
   - name: Install nginx
     shell: apt install nginx
```
> [!TIP]
> Choose apt, yum, or dnf per the distro you are using.
> - [APT](https://docs.ansible.com/projects/ansible/2.9/modules/apt_module.html#apt-module)
> - [YUM](https://docs.ansible.com/projects/ansible/2.9/modules/yum_module.html#yum-module)
> - [DNF](https://docs.ansible.com/projects/ansible/2.9/modules/dnf_module.html#dnf-module)

```YAML
---
- name: Install and start nginx
  hosts: all
  become: root

  tasks:
   - name: Install nginx
     apt:
       name: nginx
       state: present
```
#### The above was for installing Nginx, but to start it, we need to add a few lines again.
##### Using Shell
```YAML
---
- name: Install and start nginx
  hosts: all
  become: root

  tasks:
   - name: Install nginx
     apt:
       name: nginx
       state: present
   - name: Start Nginx
     shell: Systemctl start nginx     
```
##### Using [Service Module](https://docs.ansible.com/projects/ansible/2.9/modules/service_module.html#service-module){:target="_blank"}

```YAML
---
- name: Install and start nginx
  hosts: all
  become: root

  tasks:
   - name: Install nginx
     apt:
       name: nginx
       state: present
   - name: Start Nginx
     service:
       name: nginx
       state: started
```


