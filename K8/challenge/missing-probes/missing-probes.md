


```bash

[root@rhel9-4gb ~]# kubeasy challenge start missing-probes


# Starting Challenge: missing-probes

 SUCCESS  Fetching challenge details
 INFO  Challenge: Missing Probes
 SUCCESS  Checking challenge progress

 SUCCESS  Creating namespace
 SUCCESS  Deploying challenge
 SUCCESS  Kubectl context configured
 SUCCESS  Registering challenge progress

 SUCCESS  Challenge environment is ready!
Challenge: missing-probes
Namespace: missing-probes
Context: kind-kubeasy

 INFO  You can now start working on the challenge!

```
1] So as  the descripion was like,
A webapp Deployment is running in the namespace.
The application exposes two endpoints on port 8080:
  - /healthz  for liveness checks
  - /ready    for readiness checks
The pod is Running, but Kubernetes has no visibility into its actual health state.


2] This gives a clue that there should be  a healthz and ready probe should  be present.

3] I have checked the probes but it was not there.

```bash 

[root@rhel9-4gb ~]# kubectl get pods webapp-6f6f6f474d-lp9w4 -n missing-probes -o yaml |egrep -i "health|probe"
[root@rhel9-4gb ~]# 
[root@rhel9-4gb ~]# kubectl get deployments webapp -n missing-probes -o yaml |egrep -i "health|probe"
[root@rhel9-4gb ~]# 

```

4] I then went for the logs and it states that the "initialization takes ~15s" 

[root@rhel9-4gb ~]# kubectl logs webapp-6f6f6f474d-lp9w4 -n missing-probes
2026-07-05T16:13:29.769Z [webapp] Starting up — initialization takes ~15s
2026-07-05T16:13:30.265Z [webapp] Listening on port 8080
2026-07-05T16:13:45.277Z [webapp] Initialization complete. Ready to handle traffic.


5] I then check the Endpoint and found out that the Startig point of pod  and the endpoint were at same but the initialization takes ~15s.
6] Which somehow suggest that the developer created the endpoint service right after the initialization and share it with customer thus 503.

```bash
[root@rhel9-4gb ~]# kubectl get Endpointslices
NAME           ADDRESSTYPE   PORTS   ENDPOINTS     AGE
webapp-lswp6   IPv4          8080    10.244.0.36   18m

[root@rhel9-4gb ~]# kubectl describe  Endpointslices webapp-lswp6
Name:         webapp-lswp6
Namespace:    missing-probes
Labels:       endpointslice.kubernetes.io/managed-by=endpointslice-controller.k8s.io
              kubernetes.io/service-name=webapp
Annotations:  endpoints.kubernetes.io/last-change-trigger-time: 2026-07-05T16:13:29Z
AddressType:  IPv4
Ports:
  Name     Port  Protocol
  ----     ----  --------
  <unset>  8080  TCP
Endpoints:
  - Addresses:  10.244.0.36
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/webapp-6f6f6f474d-lp9w4
    NodeName:   kubeasy-control-plane
    Zone:       <unset>
Events:         <none>
[root@rhel9-4gb ~]#

```

7] Now  need to add  the probe and check if that solved our issue as currntly it helathcheck is for container not for application.

```
 Add everything from here down  under container section.
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
          initialDelaySeconds: 20
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 20
          periodSeconds: 10
		  
```

8] I have added 20 second delay, as from the logs the initialization takes ~15s

```		  
[root@rhel9-4gb ~]# kubectl edit deployments.apps webapp
deployment.apps/webapp edited

```

9] And I was able to see the result in the container logs.

```

[root@rhel9-4gb ~]# kubectl logs webapp-7d87f98d9-ddcqw
2026-07-05T16:38:00.069Z [webapp] Starting up — initialization takes ~15s
2026-07-05T16:38:00.463Z [webapp] Listening on port 8080
2026-07-05T16:38:15.385Z [webapp] Initialization complete. Ready to handle traffic.
2026-07-05T16:38:19.068Z GET /healthz
2026-07-05T16:38:21.063Z GET /ready
2026-07-05T16:38:29.066Z GET /healthz
2026-07-05T16:38:31.063Z GET /ready
2026-07-05T16:38:39.067Z GET /healthz
2026-07-05T16:38:41.063Z GET /ready
2026-07-05T16:38:49.067Z GET /healthz
2026-07-05T16:38:51.063Z GET /ready
2026-07-05T16:38:59.067Z GET /healthz
2026-07-05T16:39:01.062Z GET /ready
2026-07-05T16:39:09.066Z GET /healthz
2026-07-05T16:39:11.062Z GET /ready
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubeasy challenge submit missing-probes


# Submitting Challenge: missing-probes

 SUCCESS  Verifying challenge
 SUCCESS  Checking progress
 SUCCESS  Loading validations
 INFO  Running validations...



# Spec Validation

 SUCCESS  liveness-probe-exists: All checks passed
  ✓ All spec checks passed
 SUCCESS  liveness-probe-path: All checks passed
  ✓ All spec checks passed
 SUCCESS  readiness-probe-exists: All checks passed
  ✓ All spec checks passed
 SUCCESS  readiness-probe-path: All checks passed
  ✓ All spec checks passed



# Log Validation

 SUCCESS  probes-active: All checks passed
  ✓ Found all expected strings in logs



# Submission Result

 SUCCESS  All validations passed!

 SUCCESS  Congratulations! Challenge 'missing-probes' completed!
 INFO  You can clean up with 'kubeasy challenge clean missing-probes'

```
 
