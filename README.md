ruby on railsで作ったYouTube動画情報取得アプリです。
<br>
作者趣味のためバーチャルYouTuberを中心として作っているが、データベースを更新することで一般的なYouTuberも対応可能です。
<br>
練習のためにdeviseを使ったパスワード再設定メール自動送信機能を追加しましたが、セキュリティに関して十分推敲していないため、アカウントを作る場合個人情報を特定できないものにしてください。
公開中のページから試す場合、ユーザー登録する時メールアドレス入力に＠マークがあればメールアドレスとして認識されるので、ダミーのメールアドレスでアカウントを作れます。
<br>
APIの割り当て消耗を抑えるために削除やBANされた動画にマークをつけ、それ以降情報更新・表示しないようにしている。そのため、動画が誤BANされた場合、それ以降復活したとしても本アプリケーションでは非表示となる。

## ローカルでの起動手順（MacOS, Ruby on Rails開発環境がある前提）
### gemのインストールとデータベースの作成：
```sh
$ gem install
$ bundle install
$ rails db:create
$ rails db:migrate
```

### 初期データ導入：
テスト用に、`/DB-example`に`companies.csv`と`vtubers.csv`が用意されている。Sequel Proなどのソフトか、SQLコマンドかを使って、`companies.csv`→`vtubers.csv`順でvtb-watch_developmentのcompaniesとvtubersにインポートする。（順番を逆とすると参照エラーが発生する）

### YouTube API KEYの用意：
https://developers.google.com/youtube/v3/getting-started?hl=ja
上記のリンク先に従ってYouTube API KEYを取得する。（OAuthは不要）

`/vtb-watch`に`.env`ファイルを作り、その中に`YOUTUBE_API_KEY = '＜申請したYouTube API KEY＞'`を記入し保存する。

### 初期的なチャンネル・動画データ取得：
```sh
$ rake database:update_channel
$ rake database:update_video
$ rake database:update_liveSchedule
```

### チャンネル・動画データ定期取得設定：
`config/schedule-local.rb`を`config/schedule.rb`に名前を変更する。
```sh
$ whenever --update-crontab
```

### パスワード再設定メール自動送信機能について：
パスワード再設定メール自動送信機能はGmailを使って実装している。そのため、自分で試す場合自動送信用Gmailアカウントを先に取得し、その情報を保存する必要がある。上記の`.env`ファイルに`GMAIL_DEVELOP = '＜Gmailメールアドレス＞'`と`GMAIL_DEVELOP_PASSWORD = '＜Gmailパスワード＞'`に追記すればパスワード再設定メール自動送信機能が使えるようになる。
（Gmail以外のメールサーバを使う場合`config/environments`の環境対応`.rb`ファイルを編集する必要がある）

## おまけ
`config/schedule.rb`を修正し、crontabをアップデートすることでチャンネル・動画データ定期取得の頻度を変えることができるが、申請したYouTube API KEYの毎日使用量の割り当てを気を付けないといけない。
目安として、テスト用の`schedule-local.rb`の更新頻度の場合、vtubersが40名くらいだと、YouTube API KEYのqueries毎日使用量は10,000弱となる。（無料YouTube API KEYの毎日使用量の割り当ては10,000）