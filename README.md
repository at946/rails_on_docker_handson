# README
[SEしてるけど実はあんまりコード書いたことないんだよねって人に捧ぐ、Rails on Dockerハンズオン vol.6 - Model validation - - Qiita](https://qiita.com/at-946/items/f83dbdf12d2b286d88b7)完了時点のソースコードです。

# How to use
## Ready
1. GitHubからソースコードをクローンする。

```
$ git clone -b vol.06 git@github.com:at946/rails_on_docker_handson.git
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
