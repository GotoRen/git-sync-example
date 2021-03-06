# git-sync-example
## ð¡ Overview
- Kubernetes Sidecar pattern
![pic08](https://user-images.githubusercontent.com/63791288/110704920-fed3b980-8238-11eb-9b47-d9ea5c710655.jpg)


## ð©âð èªåã§Gitãªãã¸ããªããã®åãè¾¼ã¿ã³ã³ãããå®è£ãã
- `contents-puller.sh`
  - æå®ããGitãªãã¸ããªããå®æçã«ã³ã³ãã³ããåãè¾¼ã
  - ãªãã¸ããªã®URLã¯ç°å¢å¤æ°ã§æå®
- `Dockerfile`
  - Gitãªãã¸ããªããã®åãè¾¼ã¿ã³ã³ããã®å®ç¾©ãè¨è¿°
  - `contents-puller.sh`ãèµ·åããã ãã®ã³ã³ãã
- `webserver.yaml`
  - Sidecar Podã®ãããã§ã¹ããã¡ã¤ã«
  - `Deployment`
    - 2ã¤ã®ã³ã³ããã¨å±æããªã¥ã¼ã ãå®ç¾©
  - `Service`
    - å¤é¨ã¸å¬éããããã®NodePortãå®ç¾©

## ð Run
```
### ãããã§ã¹ããé©ç¨
$ kubectl apply -f webserver.yaml

### ã³ã³ãã¼ãã³ãä¸è¦§ã®åå¾
$ kubectl get po
NAME                         READY   STATUS    RESTARTS   AGE
webserver-6dcc867df8-qfw46   2/2     Running   0          3m25s

$ kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        29d
webserver    NodePort    10.98.144.247   <none>        80:32617/TCP   3m46s

### ã¢ã¯ã»ã¹åã®URLãåå¾
$ minikube service webserver --url
ð  Starting tunnel for service webserver.
|-----------|-----------|-------------|------------------------|
| NAMESPACE |   NAME    | TARGET PORT |          URL           |
|-----------|-----------|-------------|------------------------|
| default   | webserver |             | http://127.0.0.1:53472 |
|-----------|-----------|-------------|------------------------|
http://127.0.0.1:53472
â  Dockerãã©ã¤ãã¼ãdarwinä¸ã§åããã¦ãããããå®è¡ããã«ã¯ã¿ã¼ããã«ãéãå¿è¦ãããã¾ãã
```
- [http://locahost:53472](http://locahost:53472)
*****
## ð± æ¢å­ã®ã³ã³ããï¼git-syncï¼ãå©ç¨ãã
- `git-sync.yaml`
  - Sidecar Podã®ãããã§ã¹ããã¡ã¤ã«
  - ä¸ã§èªåã§å®è£ããè£å©ã³ã³ããï¼GitHabããã³ã³ãã³ããpullãã¦ããå½¹å²ã®ã³ã³ããï¼ã¨åæ§ã®å¦çãè¡ãã³ã³ãããå©ç¨ãã

## ð Run
```
### ãããã§ã¹ããé©ç¨
$ kubectl apply -f git-sync.yaml

### ã³ã³ãã¼ãã³ãä¸è¦§ã®åå¾
$ kubectl get po
NAME                       READY   STATUS    RESTARTS   AGE
git-sync-c65b77d57-79c52   2/2     Running   0          28s

$ kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
git-sync     NodePort    10.99.127.180   <none>        80:31023/TCP   69s
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        29d

### ã¢ã¯ã»ã¹åã®URLãåå¾
$ minikube service git-sync --url
ð  Starting tunnel for service git-sync.
|-----------|----------|-------------|------------------------|
| NAMESPACE |   NAME   | TARGET PORT |          URL           |
|-----------|----------|-------------|------------------------|
| default   | git-sync |             | http://127.0.0.1:55500 |
|-----------|----------|-------------|------------------------|
http://127.0.0.1:55500
â  Dockerãã©ã¤ãã¼ãdarwinä¸ã§åããã¦ãããããå®è¡ããã«ã¯ã¿ã¼ããã«ãéãå¿è¦ãããã¾ãã
```
- [http://127.0.0.1:55500](http://127.0.0.1:55500)

## ð Monitoring
- __Prometheus__ï¼ã°ã©ãå / ããã·ã¥ãã¼ãè¡¨ç¤º
- __Grafana__ï¼ã­ã°åæ / ãã¼ã¿å¯è¦å
```
### Build & Run
$ docker-compose up -d

### ç¢ºèª
=== * èµ·åããDockerã³ã³ãã * ===
$ docker ps
CONTAINER ID   IMAGE                                 COMMAND                  CREATED        STATUS         PORTS                                                                                                      NAMES
564a512039ec   prom/prometheus                       "/bin/prometheus --câ¦"   12 hours ago   Up 2 seconds   0.0.0.0:9090->9090/tcp                                                                                     prometheus
a0affa135a90   grafana/grafana                       "/run.sh"                12 hours ago   Up 2 seconds   0.0.0.0:3000->3000/tcp                                                                                     grafana

=== * ä½æãããDockerã¤ã¡ã¼ã¸ * ===
$ docker images
REPOSITORY                                                     TAG                                                     IMAGE ID       CREATED         SIZE
prom/prometheus                                                latest                                                  a618f5685492   3 weeks ago     175MB
grafana/grafana                                                latest                                                  c9e576dccd68   2 weeks ago     198MB

=== * ä½æãããDockerãããã¯ã¼ã¯ * ===
$ docker network ls
NETWORK ID     NAME                     DRIVER    SCOPE
1e0c95d851fe   monitoring_default       bridge    local
```