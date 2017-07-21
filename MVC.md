# MVC設計

## Model

### User

カラム            | 型       | 制約    | 備考      | 説明
----------------|----------|--------|----------|-------------------------------------------
id              | integer  | unique | 自動生成   |
name            | string   | unique |          | 一意性のあるユーザ名
email           | string   |        |          | ユーザがフォームで入力したメールアドレス
system_email    | string   |        |          | 連絡先として確認が取れているメールアドレス
created_at      | datetime |        | 自動生成   | 作成された日時
updated_at      | datetime |        | 自動生成   | 更新された日時
password_digest | string   |        | TBD      | パスワードのハッシュ値

- password周りはmigrationで対応

### Profile (TBD)

カラム       | 型        | 制約                   | 備考              | 説明
------------|----------|-----------------------|------------------|-------------------------------------------------
id          | integer  | unique                | 自動生成           |
name        | string   | user_id に対し unique  |                  | プロフィール名
nickname    | string   |                       |                  | プロフィールごとのニックネーム
default     | boolean  | Not NULL              |                  | プロフィールがデフォルトであるか
locked      | boolean  | Not NULL              | TBD              | 認証トークンにより保護されているか
lock_digest | string   |                       | TBD              | プロフィール保護に用いる認証トークンのハッシュ値
locked_at   | datetime |                       | TBD              | 保護を有効にした日時
user_id     | integer  |                       | user:references  | プロフィールを持つユーザのID
image_id    | integer  |                       | image:references | profileの画像

- 認証トークン周りはmigrationで対応予定

## Image (TBD)

カラム             | 型       | 制約    | 備考      | 説明
------------------|---------|--------|----------|-------------------------------------
id                | integer | unique | 自動生成   |
original_filename | string  |        | TBD      | アップロード画像のファイル名
data              | binary  |        | TBD      | アップロード画像のバイナリデータ
size              | integer |        | TBD      | アップロード画像のサイズ
content_type      | string  |        | TBD      | アップロード画像のcontent_type

## View

## Controller

- Users
    
    ユーザーのCLUDのため。

- Profiles
    
    プロフィールのCLUDのため。

- Sessions
    
    ログイン・ログアウトのため。

- AccountActivations
    
    アカウントをメールに記載するURLへのアクセスにより有効化するため。

- EmailChanges
    
    メールアドレスを有効性を保持しつつ変更するため。

## Routing (TBD)

HTTP動詞  | Path                                                         | #アクション               | View                        | 備考
---------|--------------------------------------------------------------|-------------------------|-----------------------------|-----------------------------------
GET      | /users                                                       | user#index              | /users/index.html.erb       | Railsリソースベース
GET      | /users/new                                                   | user#new                | /users/new.html.erb         | Railsリソースベース
POST     | /users                                                       | user#create             | N/A                         | Railsリソースベース
GET      | /users/:name                                                 | user#show               | /users/show.html.erb        | Railsリソースベース
GET      | /users/:name/edit                                            | user#edit               | /users/edit.html.erb        | Railsリソースベース
PUT      | /users/:name                                                 | user#update             | N/A                         | Railsリソースベース
DELETE   | /users/:name                                                 | user#destroy            | N/A                         | Railsリソースベース
GET      | /login                                                       | session#new             | login_path                  | 名前付きルーティング
POST     | /login                                                       | session#create          | login_path                  | 名前付きルーティング
DELETE   | /logout                                                      | session#destroy         | logout_path                 | 名前付きルーティング
GET      | /account_activation/:token/edit                              | account_activation#edit | edit_account_activation_url |
GET      | /email_change/:approve_token/edit                            | email_change#edit       | edit_email_change_url       | メールアドレスの変更承認
GET      | /email_change/:activation_token/new                          | email_change#new        | new_email_change_url        | 変更先のメールアドレスの有効性確認
GET      | /profiles/:user_name                                         | profile#index           | /profiles/index.html.erb    |
GET      | /profiles/:user_name/new                                     | profile#new             | /profiles/new.html.erb      |
POST     | /profiles/:user_name                                         | profile#create          | N/A                         |
GET      | /profiles/:user_name/:profile_name                           | profile#show            | /profiles/show.html.erb     |
GET      | /profiles/:user_name/:profile_name/edit                      | profile#edit            | /profiles/edit.html.erb     |
PUT      | /profiles/:user_name/:profile_name                           | profile#update          | N/A                         |
DELETE   | /profiles/:user_name/:profile_name                           | profile#delete          | N/A                         |
GET      | /avatar/:user_name[/:profile_name[/:locked_token[/:size]]]   | api#avatar              | TBD                         | TBD, send_data?
GET      | /avatar/:user_name[/:profile_name[/:locked_token]]/data.json | api#data_json           | /apis/data.json.erb         | TBD

### JSON data

- data.json (TBD)

```JSON
{
  "user": {
    "name": "@user.name"
  },
  "profile": {
    "name": "@profile.name",
    "nickname": "@profile.nickname"
  }
}
```
