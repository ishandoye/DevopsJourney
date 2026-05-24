# ============================================
# DAILY USE DOCKER/PODMAN COMMANDS
# VERIFIED OPERATIONAL COMMAND REFERENCE
# ============================================


# FOR MORE COMMAND VISIT - https://docs.docker.com/reference/cli/docker/

# -----------------
# CONTAINER STATUS
# -----------------

docker ps
docker ps -a
podman ps
podman ps -a

# -----------------
# IMAGE COMMANDS
# -----------------

docker images
docker image ls
podman images

# Search images from registry
docker search nginx

# Pull image
docker pull nginx:latest
podman pull nginx:latest

# Push image
docker push <repo>:<tag>
podman push <repo>:<tag>

# Tag image
docker tag nginx myrepo/nginx:v1

# Remove image
docker rmi <image>
podman rmi <image>

# Save image to tar
docker save -o image.tar <image>

# Load image from tar
docker load -i image.tar

# Export running container filesystem
docker export <container> > container.tar

# Import tar as image
docker import container.tar myimage:v1

# Image history/layers
docker history <image>
podman image tree <image>

# Inspect image
docker inspect <image>
podman inspect <image>

# -----------------
# CONTAINER EXECUTION
# -----------------

# Run interactive container
docker run -it ubuntu /bin/bash

# Run temporary container
docker run --rm -it ubuntu /bin/bash

# Run detached/background
docker run -d nginx

# Run with port mapping
docker run -d -p 8080:80 nginx

# Run with hostname
docker run --hostname app01 nginx

# Run with environment variables
docker run -e APP_ENV=prod nginx

# Run with bind mount
docker run -v /host:/container nginx

# Run with named volume
docker run -v myvol:/data nginx

# Run with custom network
docker run --network mynet nginx

# Run with CPU/memory limit
docker run --cpus 2 --memory 2g nginx

# Run read-only container
docker run --read-only nginx

# Run privileged (avoid in prod)
docker run --privileged nginx

# Run with dropped capabilities
docker run --cap-drop ALL nginx

# Run with added capability
docker run --cap-add NET_ADMIN nginx

# -----------------
# CONTAINER CONTROL
# -----------------

docker start <container>
docker stop <container>
docker restart <container>
docker kill <container>

# Pause/unpause
docker pause <container>
docker unpause <container>

# Rename container
docker rename oldname newname

# Remove container
docker rm <container>

# Force remove
docker rm -f <container>

# -----------------
# LOGS
# -----------------

docker logs <container>
docker logs -f <container>
docker logs --tail 100 <container>
docker logs --since 1h <container>

# -----------------
# EXEC / ACCESS
# -----------------

docker exec -it <container> /bin/bash
docker exec -it <container> /bin/sh

# Execute command
docker exec <container> ps -ef

# -----------------
# INSPECT / METADATA
# -----------------

docker inspect <container>

# Container state
docker inspect <container> --format='{{.State.Status}}'

# Exit code
docker inspect <container> --format='{{.State.ExitCode}}'

# OOM status
docker inspect <container> --format='{{.State.OOMKilled}}'

# Restart count
docker inspect <container> --format='{{.RestartCount}}'

# IP address
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container>

# Mounted volumes
docker inspect <container> | grep -A 20 Mounts

# Environment variables
docker inspect <container> | grep -A 20 Env

# -----------------
# RESOURCE USAGE
# -----------------

docker stats
docker stats --no-stream

# Top processes
docker top <container>

# -----------------
# NETWORKING
# -----------------

docker network ls
docker network inspect <network>

# Create network
docker network create mynet

# Connect/disconnect network
docker network connect mynet <container>
docker network disconnect mynet <container>

# Remove network
docker network rm mynet

# -----------------
# STORAGE / VOLUMES
# -----------------

docker volume ls
docker volume inspect <volume>

# Create volume
docker volume create myvol

# Remove volume
docker volume rm myvol

# -----------------
# SYSTEM / STORAGE
# -----------------

docker system df
docker system df -v
podman system df

# Docker info
docker info

# Podman info
podman info

# Docker version
docker version
podman version

# -----------------
# CLEANUP COMMANDS
# -----------------

# Remove stopped containers
docker container prune

# Remove dangling images
docker image prune

# Remove all unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Nuclear cleanup
docker system prune -a

# -----------------
# TROUBLESHOOTING
# -----------------

# Docker daemon logs
journalctl -u docker
journalctl -u containerd

# Podman logs
journalctl --user -u podman

# Kernel OOM
dmesg | grep -i oom

# Storage driver
docker info | grep "Storage Driver"

# Runtime
docker info | grep Runtime

# Check cgroup version
cat /sys/fs/cgroup/cgroup.controllers

# Check mounts
findmnt
mount | grep overlay

# Overlay usage
du -sh /var/lib/docker/overlay2
du -sh ~/.local/share/containers/storage/overlay

# Inode usage
df -i /var/lib/docker

# Open files
lsof +D /var/lib/docker

# -----------------
# NAMESPACE DEBUGGING
# -----------------

lsns
lsns -t net

# Enter namespaces
nsenter --target <pid> --mount --uts --ipc --net --pid

# -----------------
# NETWORK DEBUGGING
# -----------------

# Check routes
ip route show

# Check ports
ss -tlnp

# Check bridge interfaces
bridge link
bridge vlan
bridge fdb

# DNS inside container
docker exec -it <container> cat /etc/resolv.conf

# Connectivity test
docker exec -it <container> ping google.com

# DNS lookup
docker exec -it <container> nslookup google.com

# -----------------
# SELINUX
# -----------------

ausearch -m avc -ts recent
restorecon -Rv /path

# -----------------
# PODMAN SPECIFIC
# -----------------

# Generate systemd service
podman generate systemd --new --name <container>

# Overlay layer mapping
podman inspect $(podman ps -aq) \
--format '{{.Name}} {{.GraphDriver.Data.UpperDir}} {{.GraphDriver.Data.LowerDir}}'

# Find overlay references
grep -R '<overlay-id>' ~/.local/share/containers/storage/

# Rootless check
podman info | grep rootless

# -----------------
# BUILD COMMANDS
# -----------------

# Build image
docker build -t myapp:v1 .

# Build without cache
docker build --no-cache -t myapp:v1 .

# Multi-stage target build
docker build --target builder -t myapp:v1 .

# -----------------
# DOCKER COMPOSE
# -----------------

docker compose up -d
docker compose down
docker compose ps
docker compose logs
docker compose restart
docker compose config
