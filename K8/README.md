                kubectl
                    |
                    v
             API Server
                    |
                    v
                 etcd
                    |
      +-------------+-------------+
      |                           |
      v                           v
 Controller Manager         Scheduler
      |                           |
      +-------------+-------------+
                    |
                    v
                Kubelet
                    |
                    v
               containerd
                    |
                    v
              Linux Kernel
                    |
                    v
                Processes
