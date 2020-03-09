# README
[SEしてるけど実はあんまりコード書いたことないんだよねって人に捧ぐ、Rails on Dockerハンズオン vol.2 -Hello, Rails on Docker- - Qiita](https://qiita.com/at-946/items/45ccca274b30268f68fc)完了時点のソースコードです。

# How to use
## Ready
1. GitHubからソースコードをクローンする。

```
$ git clone -b vol.2 git@github.com:at946/rails_on_docker_handson.git
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
※vol.2時点ではマイグレーションファイルを生成していないため`db:migrate`は不要。

## コンテナ起動
```
$ docker-compose up -d
```

### コンテナ停止
```
$ docker-compose down
```


