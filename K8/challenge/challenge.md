## Installation

```bash
[root@rhel9-4gb ~]# curl -s https://api.github.com/repos/kubeasy-dev/kubeasy-cli/releases/latest | grep browser_download_url
      "browser_download_url": "https://github.com/kubeasy-dev/kubeasy-cli/releases/download/v3.0.0/checksums.txt"
      "browser_download_url": "https://github.com/kubeasy-dev/kubeasy-cli/releases/download/v3.0.0/kubeasy-cli_v3.0.0_darwin_amd64.tar.gz"
      "browser_download_url": "https://github.com/kubeasy-dev/kubeasy-cli/releases/download/v3.0.0/kubeasy-cli_v3.0.0_darwin_arm64.tar.gz"
      "browser_download_url": "https://github.com/kubeasy-dev/kubeasy-cli/releases/download/v3.0.0/kubeasy-cli_v3.0.0_linux_amd64.tar.gz"
      "browser_download_url": "https://github.com/kubeasy-dev/kubeasy-cli/releases/download/v3.0.0/kubeasy-cli_v3.0.0_linux_arm64.tar.gz"
      "browser_download_url": "https://github.com/kubeasy-dev/kubeasy-cli/releases/download/v3.0.0/kubeasy-cli_v3.0.0_windows_amd64.tar.gz"
      "browser_download_url": "https://github.com/kubeasy-dev/kubeasy-cli/releases/download/v3.0.0/kubeasy-cli_v3.0.0_windows_arm64.tar.gz"

[root@rhel9-4gb ~]# mkdir -p /tmp/kubeasy
[root@rhel9-4gb ~]# cd /tmp/kubeasy
[root@rhel9-4gb kubeasy]# curl -LO https://github.com/kubeasy-dev/kubeasy-cli/releases/download/v3.0.0/kubeasy-cli_v3.0.0_linux_amd64.tar.gz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 13.6M  100 13.6M    0     0  15.7M      0 --:--:-- --:--:-- --:--:-- 15.7M

```
```bash
[root@rhel9-4gb kubeasy]# tar -xvzf kubeasy-cli_v3.0.0_linux_amd64.tar.gz
LICENSE
README.md
kubeasy
[root@rhel9-4gb kubeasy]# ll
total 61516
-rw-r--r--. 1 1001 passport    11558 Apr 25 03:08 LICENSE
-rw-r--r--. 1 1001 passport     1899 Apr 25 03:08 README.md
-rwxr-xr-x. 1 1001 passport 48627977 Apr 25 03:08 kubeasy
-rw-r--r--. 1 root root     14340194 Jun 13 05:51 kubeasy-cli_v3.0.0_linux_amd64.tar.gz
[root@rhel9-4gb kubeasy]#
[root@rhel9-4gb kubeasy]#

[root@rhel9-4gb kubeasy]# curl -fsSL https://download.kubeasy.dev/install.sh | sh
Installing kubeasy v3.1.0 (linux/amd64) to /usr/local/bin
Downloading https://github.com/kubeasy-dev/kubeasy-cli/releases/download/v3.1.0/kubeasy-cli_v3.1.0_linux_amd64.tar.gz...
kubeasy v3.1.0 installed to /usr/local/bin/kubeasy

WARNING: /usr/local/bin is not in your PATH.
Add it by running:
  export PATH="/usr/local/bin:$PATH"

```
```bash
[root@rhel9-4gb kubeasy]# echo "export PATH="/usr/local/bin:$PATH"" >> /root/.bashrc
[root@rhel9-4gb kubeasy]# source .bashrc

```

- Once this is done, install some pacakges which are neccessary.

```bash

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker

```

```bash

[root@rhel9-4gb ~]# kubeasy setup
██   ██ ██    ██ ██████  ███████  █████  ███████ ██    ██
██  ██  ██    ██ ██   ██ ██      ██   ██ ██       ██  ██
█████   ██    ██ ██████  █████   ███████ ███████   ████
██  ██  ██    ██ ██   ██ ██      ██   ██      ██    ██
██   ██  ██████  ██████  ███████ ██   ██ ███████    ██




# Kubeasy Environment Setup


 SUCCESS  Creating kind cluster 'kubeasy' (Kubernetes 1.35.0) (completed in 22s)


# Installing Components

 SUCCESS  kyverno: ready
 SUCCESS  local-path-provisioner: ready
 SUCCESS  nginx-ingress: ready
 SUCCESS  gateway-api: ready
 SUCCESS  cert-manager: ready
 SUCCESS  kubeasy-ca: ready
 SUCCESS  cloud-provider-kind: ready

 SUCCESS  Kubeasy environment is ready!
 INFO  You can now start challenges with 'kubeasy challenge start <slug>'
[root@rhel9-4gb ~]#


[root@rhel9-4gb ~]# kubeasy challenge get pod-evicted



# Pod Evicted

Difficulty: easy
Theme: Resources & Scaling
Slug: pod-evicted

┌──────────────────────────── Description ────────────────────────────┐
| A data processing pod keeps crashing and getting evicted.           |
| It was working fine yesterday, but now Kubernetes keeps killing it. |
|                                                                     |
└─────────────────────────────────────────────────────────────────────┘


# Initial Situation

A data processing application is deployed as a single pod.
The pod starts but keeps crashing after a few seconds.
It enters a CrashLoopBackOff state and keeps restarting.
The application code hasn't changed - it was working fine in the previous environment.


 INFO  Press Enter to continue...

[root@rhel9-4gb ~]# kubeasy challenge start pod-evicted


# Starting Challenge: pod-evicted

 SUCCESS  Fetching challenge details
 INFO  Challenge: Pod Evicted
 SUCCESS  Checking challenge progress

 SUCCESS  Creating namespace
 SUCCESS  Deploying challenge
 SUCCESS  Kubectl context configured
 SUCCESS  Registering challenge progress

 SUCCESS  Challenge environment is ready!
Challenge: pod-evicted
Namespace: pod-evicted
Context: kind-kubeasy

 INFO  You can now start working on the challenge!
[root@rhel9-4gb ~]#


[root@rhel9-4gb ~]# kubectl get pods
NAME                             READY   STATUS      RESTARTS        AGE
data-processor-d66fc797f-zzbqg   0/1     OOMKilled   5 (2m14s ago)   4m4s

```
