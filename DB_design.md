# DB設計
## usersテーブル
|Column|Type|Options|
|------|----|-------|
|email|string|null: false, unique: true|
|password|integer|null: false|
|name|string|null: false, unique: true|
|icon|text||
### Association
- has_many :mylists

## mylistsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|cover|text||
|user_id|integer|foreign_key: true|
### Association
- has_many :vtubers, through: :mylist_vtubers
- has_many :mylists_vtubers
- belongs_to :user

## vtubersテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true|
|twitter|string|null: false, unique: true|
|company_id|integer|foreign_key: true|
|channel|string|null: false, unique: true|
### Association
- has_many :mylists, through: :mylist_vtubers
- has_many :mylists_vtubers
- belongs_to :company
- has_many :videos

## mylists_vtubersテーブル
|Column|Type|Options|
|------|----|-------|
|mylist_id|integer|foreign_key: true|
|vtuber_id|integer|foreign_key: true|
### Association
- belongs_to :mylist
- belongs_to :vtuber

## videosテーブル
|Column|Type|Options|
|------|----|-------|
|videoId|string||
|name|string|null: false|
|scheduledStartTime|datetime||
|actualStartTime|datetime||
|actualEndTime|datetime||
|vtuber_id|integer|foreign_key: true|
### Association
- belongs_to :vtuber

## companiesテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true|
### Association
- has_many :vtubers