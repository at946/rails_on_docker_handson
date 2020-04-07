# README
[コーディング未経験のPO/PdMのためのRails on Dockerハンズオン、Rails on Dockerハンズオン vol.13 - TDDでPost機能をコーディング part2 - - Qiita](https://qiita.com/at-946/items/ff66e73ca8750c9a8790)完了時点のソースコードです。

# How to use
## Ready
1. GitHubからソースコードをクローンする。

```
$ git clone -b vol.14 git@github.com:at946/rails_on_docker_handson.git
```

2. Dockerイメージをビルドする。

```
$ cd rails_on_docker_handson
$ docker-compose build
```

3. Yarnをインストールする

```
$ docker-compose run --rm web yarn install --check-files
```

4. DBを作成し、マイグレーションを適用する。

```
$ docker-compose run --rm web rails db:create
$ docker-compose run --rm web rails db:migrate
```

## コンテナ起動
```
$ docker-compose up -d
```

### コンテナ停止
```
$ docker-compose down
```
