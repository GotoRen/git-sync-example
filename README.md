# git-sync-example
## 💡 Overview
- Kubernetes Sidecar patternを試す

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
$ kubectl get svc

### アクセス先のURLを取得
$ minikube service webserver --url
```
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
$ kubectl get svc

### アクセス先のURLを取得
$ minikube service git-sync --url
```