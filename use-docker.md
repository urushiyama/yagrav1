# dockerでテスト環境を動かす

## 要件

- テスト環境を動かすマシン上にdockerがインストールされていること
- dockerを起動するマシン上にdocker-composeがインストールされていること
  - 以下のドキュメントはユーザー権限でDockerとdocker-composeが動かせることを想定

## Railsコンテナを起動する

多分これでうごく。

```console
$ # git clone git@github.com:urushiyama/yagrav1.git
$ # cd yagrav1
$ docker-compose build
$ docker-compose up -d
```

## railsコマンドを叩く

コンテナが起動していることを前提とする。

```console
$ docker-compose exec yagrav1_web \
  bundle exec rails <command...>
```

## Railsサーバーを終了する

```console
$ # cd your/cloned/yagrav1
$ docker-compose down
```

## Railsアプリの初期設定

リポジトリからクローンする際には不要です。自分のためのメモ。

参考: [Quickstart: Compose and Rails | Docker Documentation](https://docs.docker.com/compose/rails/)

1. Railsアプリケーションの新規作成

すでにGitの管理下にある場合:

```console
$ docker-compose run yagrav1_web \
  rails new . --force --database=postgresql -G
```

Gitも新たに作成する場合は`-G`オプションを除いて実行する。

作成された新しいGemfileでimageを再度buildする。

```console
$ docker-compose build
```

その後、Railsアプリのconfig/database.ymlをyagrav1_dbコンテナ上にアクセスするよう修正する。

```diff
  17      default: &default
  18      adapter: postgresql
  19      encoding: unicode
+     20  host: yagrav1_db
+     21  username: postgres
+     22  password:
  20  23  # For details on connection pooling, see Rails configuration guide
  21  24  # http://guides.rubyonrails.org/configuring.html#database-pooling
  22  25  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

ここまできたら一度Railsサーバーを起動してみる。

```console
$ docker-compose up
```

最後に、pg上にtest環境とdevelopment環境用のデータベースを作成する。
新しい端末を開き、

```console
$ docker-compose run yagrav1_web rake db:create
Starting yagrav1_yagrav1_db_n ... done
=> Created database 'app_development'
=> Created database 'app_test'
```

これで、Dockerを起動しているマシン上から http://localhost:3000/ にアクセスするか、`http://[起動しているマシンのローカルアドレス]:3000/`にアクセスすることでRails Welcomeページが表示されるはず。
