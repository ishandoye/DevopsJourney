
 # DAILY USE DOCKER/PODMAN COMMANDS


## FOR MORE COMMAND VISIT - https://docs.docker.com/reference/cli/docker/

-----------------
## CONTAINER STATUS
-----------------
```bash
# docker ps
# docker ps -a
# podman ps
# podman ps -a
```
-----------------
## IMAGE COMMANDS
----------------
```bash
# docker images
# docker image ls
# podman images
```
###  Search images from registry
```bash
# docker search nginx
```
### Pull image
```bash
# docker pull nginx:latest
# podman pull nginx:latest
```
### Push image
```bash
# docker push <repo>:<tag>
# podman push <repo>:<tag>
```
### Tag image
```bash
# docker tag nginx myrepo/nginx:v1
```
### Remove image
```bash
# docker rmi <image>
# podman rmi <image>
```
###  Save image to tar
```bash
# docker save -o image.tar <image>
```
### Load image from tar
```bash
# docker load -i image.tar
```
### Export running container filesystem
```bash
# docker export <container> > container.tar
```
### Import tar as image
```bash
# docker import container.tar myimage:v1
```
### Image history/layers
```bash
# docker history <image>
# podman image tree <image>
```
## Inspect image
```bash
# docker inspect <image>
# podman inspect <image>
```
-----------------
### CONTAINER EXECUTION
-----------------
### Run interactive container
```bash
# docker run -it ubuntu /bin/bash
```
### Run temporary container
```bash
#docker run --rm -it ubuntu /bin/bash
```
### Run detached/background
```bash
# docker run -d nginx
```
### Run with port mapping
```bash
# docker run -d -p 8080:80 nginx
```
### Run the port, but don’t care which host port is used.
```bash
# docker run -p 80 nginx
```
### Publishing all ports
```bash
"With the -P or --publish-all flag, you can automatically publish all exposed ports to ephemeral ports.
This is quite useful when you’re trying to avoid port conflicts in development or testing environments."

# docker run -P nginx
```
### Run with hostname
```bash
# docker run --hostname app01 nginx
```
### Run with environment variables
```bash
# docker run -e APP_ENV=prod nginx
```
### Run with bind mount
```bash
# docker run -v /host:/container nginx
```
### Run with named volume
```bash
# docker run -v myvol:/data nginx
```
### Run with custom network
```bash
# docker run --network mynet nginx
```
### Run with CPU/memory limit
```bash
# docker run --cpus 2 --memory 2g nginx
```
### Run read-only container
```bash
# docker run --read-only nginx
```
### Run privileged (avoid in prod)
```bash
"
## A privileged container’s root user has the same rights as the host's root user.
## If an attacker compromises the container, they can gain full control over the underlying node, modify system files, and potentially access the entire cluster"

# docker run --privileged nginx
```
### Run with dropped capabilities
```bash
docker run --cap-drop ALL nginx
```
### Run with added capability
```bash
# docker run --cap-add NET_ADMIN nginx
```
-----------------
## CONTAINER CONTROL
-----------------
```bash

# docker start <container>
# docker stop <container>
# docker restart <container>
# docker kill <container>

PAUSE_UNPAUSE_COMMANDS:

# docker pause <container>
# docker unpause <container>

RENAME CONTAINER:
# docker rename oldname newname

REMOVE CONTAINER
# docker rm <container>

FORCE REMOVE
# docker rm -f <container>
```
-----------------
## LOGS
-----------------
```bash
# docker logs <container>
# docker logs -f <container>
# docker logs --tail 100 <container>
# docker logs --since 1h <container>
```
-----------------
## EXEC / ACCESS
-----------------
```bash
# docker exec -it <container> /bin/bash
# docker exec -it <container> /bin/sh
```
### Execute command
```bash
# docker exec <container> ps -ef
```
-----------------
## INSPECT / METADATA
-----------------
```bash
# docker inspect <container>
```
### Container state
```bash
# docker inspect <container> --format='{{.State.Status}}'
```
### Exit code
```bash
# docker inspect <container> --format='{{.State.ExitCode}}'
```
### OOM status
```bash
# docker inspect <container> --format='{{.State.OOMKilled}}'
```
### Restart count
```bash
# docker inspect <container> --format='{{.RestartCount}}'
```
### IP address
```bash
# docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container>
```
### Mounted volumes
```bash
# docker inspect <container> | grep -A 20 Mounts
```
### Environment variables
```bash
# docker inspect <container> | grep -A 20 Env
```
-----------------
## RESOURCE USAGE
-----------------
```
# docker stats
# docker stats --no-stream

TOP PROCESSES
# docker top <container>
```
-----------------
## NETWORKING
-----------------
```bash
# docker network ls
# docker network inspect <network>
```
### Create network
```bash
# docker network create mynet
```
### Connect/disconnect network
```bash
# docker network connect mynet <container>
# docker network disconnect mynet <container>
```
### Remove network
```bash
# docker network rm mynet
```
-----------------
## STORAGE / VOLUMES
-----------------
```
# docker volume ls
# docker volume inspect <volume>

CREATE VOLUME:
# docker volume create myvol

REMOVE VOLUME:
# docker volume rm myvol
```
-----------------
## SYSTEM / STORAGE
-----------------
```bash
# docker system df
# docker system df -v
# podman system df

DOCKER INFO:

# docker info

PODMAN INFO:

# podman info

DOCKER VERSION

# docker version
# podman version
```
-----------------
## CLEANUP COMMANDS
-----------------
```bash
REMOVE STOPPED CONTAINERS:

# docker container prune

REMOVE DANGLING IMAGES:

# docker image prune

REMOVE ALL UNUSED IMAGES:

# docker image prune -a

REMOVE USUSED VOLUMES:

# docker volume prune

REMOVE UNUSED NETWORKS:

#docker network prune

NUCLEAR CLEANUP:

# docker system prune -a
```
-----------------
## TROUBLESHOOTING
-----------------
```bash

DOCKER DAEMON LOGS:

# journalctl -u docker
# journalctl -u containerd

PODMAN LOGS

# journalctl --user -u podman

KERNEL OOM

# dmesg | grep -i oom

STORAGE DRIVER:

# docker info | grep "Storage Driver"

RUNTIME:

# docker info | grep Runtime
```
### Check cgroup version
```bash
# cat /sys/fs/cgroup/cgroup.controllers
```
### Check mounts
```bash
# findmnt
# mount | grep overlay
```
### Overlay usage
```bash
# du -sh /var/lib/docker/overlay2
# du -sh ~/.local/share/containers/storage/overlay
```
### Inode usage
```bash
# df -i /var/lib/docker
```
### Open files
```
# lsof +D /var/lib/docker
```

-----------------
## NAMESPACE DEBUGGING
-----------------
```bash
# lsns
# lsns -t net

ENTER NAMESPACES:

# nsenter --target <pid> --mount --uts --ipc --net --pid
```
-----------------
## NETWORK DEBUGGING
-----------------
```bash
CHECK ROUTES:

# ip route show

CHECK PORTS:

# ss -tlnp

CHECK BRIDGE INTERFACES:

# bridge link
# bridge vlan
# bridge fdb

DNS INSIDE CONTAINER:

# docker exec -it <container> cat /etc/resolv.conf

CONECTIVITY TEST:

# docker exec -it <container> ping google.com

DNS LOOKUP:

# docker exec -it <container> nslookup google.com
```
-----------------
## SELINUX
-----------------
```bash
# ausearch -m avc -ts recent
# restorecon -Rv /path
```
-----------------
## PODMAN SPECIFIC
-----------------
```bash

GENERATE SYSTEMD SERVICE:

# podman generate systemd --new --name <container>

OVERLAY LAYER MAPPING:

# podman inspect $(podman ps -aq) --format '{{.Name}} {{.GraphDriver.Data.UpperDir}} {{.GraphDriver.Data.LowerDir}}'

FIND OVERLAY REFERENCES:

# grep -R '<overlay-id>' ~/.local/share/containers/storage/

ROOTLESS CHECK:

# podman info | grep rootless
```
-----------------
## BUILD COMMANDS
-----------------
```
BUID IMAGES:

# docker build -t myapp:v1 .

BUILD WITHOUT CACHE:

# docker build --no-cache -t myapp:v1 .

MULTI-STAGE TARGET BUILD:

# docker build --target builder -t myapp:v1 .
```

-----------------
## DOCKER COMPOSE
-----------------
```bash
# docker compose up -d
# docker compose down
# docker compose ps
# docker compose logs
# docker compose restart
# docker compose config
```
