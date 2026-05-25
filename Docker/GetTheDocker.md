##### Installation #############

```bash
# dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
# dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# systemctl enable --now docker.s
# systemctl enable --now docker.service
```
##### Run your first container #####
```bash
# docker run -d -p 8000:80 docker/welcome-to-docker
```
