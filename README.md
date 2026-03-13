# README

## What is rask?

raskとは，タスクを管理する機能と議事録を作成する機能を持つアプリケーションである．
raskには以下のような特徴を持つ．
- タスク管理は[Getting Things Done(GTD)](https://www.amazon.co.jp/Getting-Things-Done-Stress-Free-Productivity/dp/0143126563)に対応
- 議事録はMarkdownを用いて作成

## Setup

rask は Docker を使用して起動できるスクリプトを用意している．
このため，計算機上では Docker が使用できることを前提とする．
### Clone rask
GitHubよりraskのリポジトリをcloneし，リポジトリ内へ移動する．
```
$ git clone https://github.com/nomlab/rask.git
$ cd rask
```
### Setup config files
- 以下のコマンドを使用し，.env.example から .envをコピーする．
  ```
  $ cp .env.example .env
  ```

- OAuth App の作成
  https://github.com/settings/developers にアクセスし，OAuth App を作成する．
  この際，Homepage URL には rask のホームページのURLを入力し，Authorization callback URL には <raskのホームページのURL>/auth/github/callbackを入力する．
  例えば手元の計算機で環境を構築し，3000番ポートを使用する場合，HomePage URL には http://localhost:3000 を設定し，Authorization callback URL には http://localhost:3000/auth/github/callback を設定する．

- client id，client secret，および allowed team id の設定
  .envの内容は以下のようになっている．
  ```
  1 GITHUB_CLIENT_ID=XXXXXXXXXXXXXXXXXXXX
  2 GITHUB_CLIENT_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  3 OAUTH_GITHUB_ALLOWED_TEAM_ID=XXXXX
  ```

  - GITHUB_CLIENT_ID には先ほど作成した OAuth App の Client ID を入力する．
  - GITHUB_CLIENT_SECRET には OAuth App の Client secrets を入力する．
    ここで，新しい Client secrets を作成する場合，「Generate a new client secret」より作成する．
  - OAUTH_GITHUB_ALLOWED_TEAM_ID は以下のコマンドを実行し，取得したidを入力する．
    ```
    curl -H "Authorization: token <access_token>" https://api.github.com/orgs/<your_organization>/teams
    ```
    上記のコマンドのうち，\<access_token> には GitHub ユーザの Access Token を入力する．
    ここで，新しい Access Token を作成する場合，Settings から Developer settings -> Personal access tokens と移動し，New personal access token より新しい Token を作成する．
    この際，Select scopes より read:org にチェックを入れる必要がある．
    また，\<your_organization> には GitHub ユーザが所属するチーム名を入力する．

## Development
rask の開発には docker-compose を使用する．
このため，docker-compose をインストールし，以下のコマンドを用いて開発を行うとよい．

- サーバ起動
  ```
  $ make up
  ```
- Gemfile の更新などによる依存関係の再インストール (Bundle install)
  ```
  $ make setup
  ```
- テスト実行
  ```
  $ make rails-test
  ```
- サーバ停止
  ```
  $ make down
  ```
## Production
### スクリプトを用いた管理
- コンテナイメージの作成
  ```
  $ scripts/setup-production-container.sh <UserName>
  ```
  上記のコマンドのうち，\<UserName> は rask のコンテナを起動するユーザである．

  - Why does \<UserName> need?

    Dockerを用いてファイルを作成したとき，既定だと所有者がrootユーザで作成される．
    このため，データベースを保存するファイルがrootユーザで作成されてしまい，他のユーザがデータベースを使用できない．
    そこで，```scripts/setup-docker.sh``` と ```scripts/rask-docker.sh``` を用いることで，所有者を指定してデータベースが作成し，raskを使用できる．
    これにより，root以外のユーザでもデータベースを使用できるようになる．

- 起動
  ```
  $ bin/launch-production start [-p PORT] [-t TAG] [-a/-d]
  ```
  - オプション
    1. `-p PORT`: rask のコンテナをバインドするポート番号．デフォルトは 3000．
    2. `-t TAG`: rask イメージのタグ．"-t v1.0.1"と指定されると"rask:v1.0.1"のイメージを使用する．デフォルトは "latest"
    3. `-a/-d`: コンテナにアタッチ(-a)するかデタッチ(-d)するか．デフォルトは -a．

- 停止
  ```
  $ bin/launch-production stop
  ```
  Raskコンテナを停止する．

- 状態確認
  ```
  $ bin/launch-production status
  ```

- 再起動
  ```
  $ bin/launch-production restart
  ```

### systemd を用いた管理

`systemd` を用いて rask を起動したい場合は以下の手順を行う．

1. サービスファイルを配置
    ```
    $ cp scripts/systemd_conf/rask.service /etc/systemd/system/
    ```

2. `/etc/systemd/system/rask.service` の書き換え
    ```
    6	[Service]
    7	# Change path to suit your environment
    8	WorkingDirectory=<Path to rask repository>
    9	ExecStart=<Path to rask repository>/bin/launch-production start -p 3000
    10	ExecStop=<Path to rask repository>/bin/launch-production stop
    11
    12	# Change user who owns this repository
    13	User=rask
    ```
    - `<Path to rask repository>` を Rask が保存されているフォルダのパスに変更する．
    - `User=rask` を Rask を使用するユーザに変更する．基本的には Rask ディレクトリのオーナーを指定することを推奨．

3. Rask のサービスファイルを `systemd` に反映
    ```
    $ systemctl daemon-reload
    ```

4. `systemd` を用いて rask を起動
    ```
    $ systemctl start rask.service
    $ systemctl status rask.service
    ● rask.service - Rask: Task Management System
       Loaded: loaded (/etc/systemd/system/rask.service; enabled; vendor preset: enabled)
       Active: active (running) since Tue YYYY-MM-DD hh:mm:ss JST;
     Main PID: XXXX (rask-docker.sh)
       Tasks: XX (limit: XXXXX)
       Memory: XX.XM
       CGroup: /system.slice/rask.service
    ```

5. 計算機起動時に自動起動する
    ```
    $ systemctl enable rask.service
    ```

### 自動更新
* Rask に新たな Release が作成された際に自動更新できる．
* 本スクリプトは Rask が systemd で管理されている状態でのみ機能する．
#### 手順
1. `scripts/systemd_conf/rask-autoupdate.service` および `scripts/systemd_conf/rask-autoupdate.timer` を `/etc/systemd/system/` 以下にコピーする
    ```bash
    sudo cp scripts/systemd_conf/rask-autoupdate.* /etc/systemd/system/
    ```
2. 上記の2ファイルの内容を自身の環境に合わせて変更する
    ```
    # /etc/systemd/system/rask-autoupdate.service
    - User=rask-user
    + User=nomlab

    - ExecStart=/path/to/rask/script/update_rask.sh
    + ExecStart=/home/nomlab/rask/scripts/update_rask.sh
    ```
    ```
    # /etc/systemd/system/rask-autoupdate.timer
    - OnCalendar=*-*-* 10:00:00
    + OnCalendar=*-*-* 23:00:00
    ```
3. systemd の自動実行を有効にする
    ```bash
    sudo systemctl enable rask-autoupdate.timer
    ```

## [CLI](./cli)
* Rask の API を利用してコマンドラインから Rask を操作できる CLI ツール
* 詳細は [こちら](./cli/README.md)
