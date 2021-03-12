# git-sync-example
## 💡 Overview
- Kubernetes Sidecar pattern
![pic08](https://user-images.githubusercontent.com/63791288/110704920-fed3b980-8238-11eb-9b47-d9ea5c710655.jpg)


## 👩‍🚒 自力でGitリポジトリからの取り込みコンテナを実装する
- `contents-puller.sh`
  - 指定したGitリポジトリから定期的にコンテンツを取り込む
  - リポジトリのURLは環境変数で指定
- `Dockerfile`
  - Gitリポジトリからの取り込みコンテナの定義を記述
  - `contents-puller.sh`を起動するだけのコンテナ
- `webserver.yaml`
  - Sidecar Podのマニフェストファイル
  - `Deployment`
    - 2つのコンテナと共有ボリュームを定義
  - `Service`
    - 外部へ公開するためのNodePortを定義

## 🚀 Run
```
### マニフェストを適用
$ kubectl apply -f webserver.yaml

### コンポーネント一覧の取得
$ kubectl get po
NAME                         READY   STATUS    RESTARTS   AGE
webserver-6dcc867df8-qfw46   2/2     Running   0          3m25s

$ kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        29d
webserver    NodePort    10.98.144.247   <none>        80:32617/TCP   3m46s

### アクセス先のURLを取得
$ minikube service webserver --url
🏃  Starting tunnel for service webserver.
|-----------|-----------|-------------|------------------------|
| NAMESPACE |   NAME    | TARGET PORT |          URL           |
|-----------|-----------|-------------|------------------------|
| default   | webserver |             | http://127.0.0.1:53472 |
|-----------|-----------|-------------|------------------------|
http://127.0.0.1:53472
❗  Dockerドライバーをdarwin上で動かしているため、実行するにはターミナルを開く必要があります。
```
- [http://locahost:53472](http://locahost:53472)
*****
## 🌱 既存のコンテナ（git-sync）を利用する
- `git-sync.yaml`
  - Sidecar Podのマニフェストファイル
  - 上で自力で実装した補助コンテナ（GitHabからコンテンツをpullしてくる役割のコンテナ）と同様の処理を行うコンテナを利用する

## 🚀 Run
```
### マニフェストを適用
$ kubectl apply -f git-sync.yaml

### コンポーネント一覧の取得
$ kubectl get po
NAME                       READY   STATUS    RESTARTS   AGE
git-sync-c65b77d57-79c52   2/2     Running   0          28s

$ kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
git-sync     NodePort    10.99.127.180   <none>        80:31023/TCP   69s
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        29d

### アクセス先のURLを取得
$ minikube service git-sync --url
🏃  Starting tunnel for service git-sync.
|-----------|----------|-------------|------------------------|
| NAMESPACE |   NAME   | TARGET PORT |          URL           |
|-----------|----------|-------------|------------------------|
| default   | git-sync |             | http://127.0.0.1:55500 |
|-----------|----------|-------------|------------------------|
http://127.0.0.1:55500
❗  Dockerドライバーをdarwin上で動かしているため、実行するにはターミナルを開く必要があります。
```
- [http://127.0.0.1:55500](http://127.0.0.1:55500)

## 🔎 Monitoring
- __Prometheus__：グラフ化 / ダッシュボード表示
- __Grafana__：ログ分析 / データ可視化
```
### Build & Run
$ docker-compose up -d

### 確認
=== * 起動するDockerコンテナ * ===
$ docker ps
CONTAINER ID   IMAGE                                 COMMAND                  CREATED        STATUS         PORTS                                                                                                      NAMES
564a512039ec   prom/prometheus                       "/bin/prometheus --c…"   12 hours ago   Up 2 seconds   0.0.0.0:9090->9090/tcp                                                                                     prometheus
a0affa135a90   grafana/grafana                       "/run.sh"                12 hours ago   Up 2 seconds   0.0.0.0:3000->3000/tcp                                                                                     grafana

=== * 作成されるDockerイメージ * ===
$ docker images
REPOSITORY                                                     TAG                                                     IMAGE ID       CREATED         SIZE
prom/prometheus                                                latest                                                  a618f5685492   3 weeks ago     175MB
grafana/grafana                                                latest                                                  c9e576dccd68   2 weeks ago     198MB

=== * 作成されるDockerネットワーク * ===
$ docker network ls
NETWORK ID     NAME                     DRIVER    SCOPE
1e0c95d851fe   monitoring_default       bridge    local
```