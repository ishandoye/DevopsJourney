[root@node Docker]# cd getting-started-todo-app/
[root@node getting-started-todo-app]# ll
total 28
drwxr-xr-x. 4 root root    74 May 24 09:58 backend
drwxr-xr-x. 4 root root   155 May 24 09:58 client
-rw-r--r--. 1 root root  7260 May 24 09:58 compose.yaml
-rw-r--r--. 1 root root  3090 May 24 09:58 Dockerfile
-rw-r--r--. 1 root root 11340 May 24 09:58 LICENSE
-rw-r--r--. 1 root root  2138 May 24 09:58 README.md
[root@node getting-started-todo-app]# docker build .
[+] Building 69.7s (22/22) FINISHED                                                                                                                                                                 docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                                          0.0s
 => => transferring dockerfile: 3.19kB                                                                                                                                                                        0.0s
 => [internal] load metadata for docker.io/library/node:22                                                                                                                                                    0.5s
 => [internal] load .dockerignore                                                                                                                                                                             0.0s
 => => transferring context: 112B                                                                                                                                                                             0.0s
 => [base 1/2] FROM docker.io/library/node:22@sha256:1031993481795705055273f2eef0c24597abdcb277d6e058c82f78cbbdef92a6                                                                                         0.0s
 => => resolve docker.io/library/node:22@sha256:1031993481795705055273f2eef0c24597abdcb277d6e058c82f78cbbdef92a6                                                                                              0.0s
 => [internal] load build context                                                                                                                                                                             0.0s
 => => transferring context: 241.41kB                                                                                                                                                                         0.0s
 => CACHED [base 2/2] WORKDIR /usr/local/app                                                                                                                                                                  0.0s
 => CACHED [backend-dev 1/4] COPY backend/package.json backend/package-lock.json ./                                                                                                                           0.0s
 => CACHED [backend-dev 2/4] RUN npm install                                                                                                                                                                  0.0s
 => CACHED [backend-dev 3/4] COPY backend/spec ./spec                                                                                                                                                         0.0s
 => CACHED [client-base 1/5] COPY client/package.json client/package-lock.json ./                                                                                                                             0.0s
 => CACHED [client-base 2/5] RUN npm install                                                                                                                                                                  0.0s
 => CACHED [client-base 3/5] COPY client/.eslintrc.cjs client/index.html client/vite.config.js ./                                                                                                             0.0s
 => CACHED [client-base 4/5] COPY client/public ./public                                                                                                                                                      0.0s
 => CACHED [client-base 5/5] COPY client/src ./src                                                                                                                                                            0.0s
 => [backend-dev 4/4] COPY backend/src ./src                                                                                                                                                                  0.0s
 => [client-build 1/1] RUN npm run build                                                                                                                                                                      5.0s
 => [test 1/1] RUN npm run test                                                                                                                                                                               1.3s
 => CACHED [final 1/4] COPY --from=test /usr/local/app/package.json /usr/local/app/package-lock.json ./                                                                                                       0.0s
 => [final 2/4] RUN npm ci --production &&     npm cache clean --force                                                                                                                                       63.4s
 => [final 3/4] COPY backend/src ./src                                                                                                                                                                        0.1s
 => [final 4/4] COPY --from=client-build /usr/local/app/dist ./src/static                                                                                                                                     0.0s
 => exporting to image                                                                                                                                                                                        4.0s
 => => exporting layers                                                                                                                                                                                       2.7s
 => => exporting manifest sha256:eb1671e27ddeb3d6510a50872cf22817803025a83ef4a09c41301adaee2f439c                                                                                                             0.0s
 => => exporting config sha256:1d38bae55005228c95a5e8b63e7a351d57d458d1e03e17fa7d0f75e5a6ec406b                                                                                                               0.0s
 => => exporting attestation manifest sha256:4f3220b62e10225b8bcfb51a9cc4f507657fbdaa3343286b85fa98fdeb5ce1c8                                                                                                 0.0s
 => => exporting manifest list sha256:fae8070c80e9922b62d236e223cc6db678014de41e31970d9931f42ab6d42a0e                                                                                                        0.0s
 => => naming to moby-dangling@sha256:fae8070c80e9922b62d236e223cc6db678014de41e31970d9931f42ab6d42a0e                                                                                                        0.0s
 => => unpacking to moby-dangling@sha256:fae8070c80e9922b62d236e223cc6db678014de41e31970d9931f42ab6d42a0e                                                                                                     1.3s
[root@node getting-started-todo-app]#
[root@node getting-started-todo-app]#
[root@node getting-started-todo-app]# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
[root@node getting-started-todo-app]# docker image ls
                                                                                                                                                                                               i Info →   U  In Use
IMAGE                                                                                             ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:latest                                                                                     5b10f432ef3d       12.7MB         3.95MB
getting-started-todo-app-backend:latest                                                           ecaadfa8c324       1.83GB          453MB    U
getting-started-todo-app-client:latest                                                            eb8e5cf04823       1.83GB          456MB    U
ghcr.io/open-feature/flagd:v0.12.9                                                                e6cca86b2962        167MB         48.4MB    U
ghcr.io/open-telemetry/demo:2.1.3-accounting                                                      3c3e43749547        387MB          109MB    U
ghcr.io/open-telemetry/demo:2.1.3-ad                                                              c9d4f9431493        545MB          166MB    U
ghcr.io/open-telemetry/demo:2.1.3-cart                                                            84ce75e56697        155MB         48.4MB    U
ghcr.io/open-telemetry/demo:2.1.3-checkout                                                        f000c1de3717       34.7MB         8.66MB    U
ghcr.io/open-telemetry/demo:2.1.3-currency                                                        3192c30c8aa8        130MB         30.5MB    U
ghcr.io/open-telemetry/demo:2.1.3-email                                                           5a62bbc4c7f3        268MB         91.1MB    U
ghcr.io/open-telemetry/demo:2.1.3-flagd-ui                                                        676cbe548111        203MB         49.8MB    U
ghcr.io/open-telemetry/demo:2.1.3-fraud-detection                                                 e480771f5082        458MB          158MB    U
ghcr.io/open-telemetry/demo:2.1.3-frontend                                                        eea527d9d8b0       1.06GB          241MB    U
ghcr.io/open-telemetry/demo:2.1.3-frontend-proxy                                                  33064c977f50        238MB         61.4MB    U
ghcr.io/open-telemetry/demo:2.1.3-image-provider                                                  62caa5566239        136MB         40.5MB    U
ghcr.io/open-telemetry/demo:2.1.3-kafka                                                           b91f13e3d4c2        605MB          224MB    U
ghcr.io/open-telemetry/demo:2.1.3-load-generator                                                  b35d080e7127       2.24GB          564MB    U
ghcr.io/open-telemetry/demo:2.1.3-payment                                                         342c8ce5e0cf        336MB         72.6MB    U
ghcr.io/open-telemetry/demo:2.1.3-postgresql                                                      e7a65215e538        634MB          161MB    U
ghcr.io/open-telemetry/demo:2.1.3-product-catalog                                                 5af68959300c       30.6MB         7.51MB    U
ghcr.io/open-telemetry/demo:2.1.3-quote                                                           f44773a546d3        178MB         45.1MB    U
ghcr.io/open-telemetry/demo:2.1.3-recommendation                                                  6ec8ee18b8cd        141MB         34.2MB    U
ghcr.io/open-telemetry/demo:2.1.3-shipping                                                        9fb2bd7960a2       55.4MB         15.2MB    U
ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-contrib:0.133.0   98274b756324        439MB         90.8MB    U
grafana/grafana:12.2.0                                                                            74144189b384        970MB          204MB    U
jaegertracing/jaeger:2.10.0                                                                       8c593d8048d8        173MB         51.6MB    U
mysql:9.3                                                                                         b9d8b7ec6e6a       1.18GB          273MB    U
phpmyadmin:latest                                                                                 7dfd52c45204        811MB          197MB    U
quay.io/prometheus/prometheus:v3.5.0                                                              63805ebb8d2b        440MB          124MB    U
traefik:v3.6                                                                                      802adc80a7bb        244MB         54.1MB    U
ubuntu:latest                                                                                     f3d28607ddd7        158MB         45.3MB    U
ultimate-devops-project-demo-opensearch:latest                                                    c22a74802686       2.47GB         1.01GB    U
valkey/valkey:8.1.3-alpine                                                                        d827e7f7552c       69.2MB         19.8MB    U
[root@node getting-started-todo-app]#

