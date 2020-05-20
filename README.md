
# README

## Usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false,unique:true|
|email|string|null: false,unique:true|
|password|string|null:false,default""|
|first_name|string|null:false,default""|
|last_name|string|null:false,default""|
|first_kana|string|null:false,default""|
|last_kana|string|null:false,default""|
|birthday|data|null:false|
|tel|string||
|good|integer|null:false,default: 0|
|normal|integer|null:false,default: 0|
|bad|integer|null:false,default: 0|
|image|text||
|profile|string||
|post_number|string|null:false,default""|
|prefecture_id|integer|foreign_key|
|city|string|null:false,default""|
|address|string|null:false,default""|
|build_name|string||
### Association
- has_many :comments
- has_many :items
- has_many :likes
- belongs_to :prefectures
 
## items テーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|detail|text|null: false|
|price|integer|null: false|
|brand_id|integer|foreign_key: true|
|pay_side_id|integer|null :false, foreign_key: true|
|post_date_id|integer|null :false, foreign_key: true|
|status_id|integernull :false, |foreign_key: true|
|prefecture_id|integer|null :false, foreign_key: true|
|category_id|integer|null :false, foreign_key: true|
|user_id|integer|null :false, foreign_key: true|
### Association
- has_many :likes
- has_many :images
- has_many :comments
- has_many :categories through: :item_categories
- belongs_to :users
- belongs_to :prefectures
- belongs_to :brand
- belongs_to :pay_side
- belongs_to :post_date
- belongs_to :status
 
## commentsテーブル
|Column|Type|Options|
|------|----|-------|
|comment|text|null: false|
|user_id|integer|foreign_key: true|
|item_id|integer|foreign_key: true|
### Association
- belongs_to :user
- belongs_to :item
 
## brandsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
### Association
- has_many :items
 
## pay_sidesテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
### Association
- has_many :items
 
## post_dateテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
### Association
- has_many :items
 
## statusesテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
### Association
- has_many :items
 
## imagesテーブル
|Column|Type|Options|
|------|----|-------|
|url|text|null: false|
|item_id|integer|foreign_key: true|
### Association
- belongs_to :item
 
## item_categoriesテーブル
|Column|Type|Options|
|------|----|-------|
|item_id|integer|null: false, foreign_key: true|
|categories_id|integer|null:false, foreign_key: true|
### Association
- has_many :items
- has_many :categories
 
## prefecturesテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null:false,default""|
### Association
- has_many :users
 
## likesテーブル
|Column|Type|Options|
|------|----|-------|
|num|integer|null:false,default:0|
|name|integer|foreign_key: true|
|name|integer|foreign_key: true|
### Association
- belongs_to :items
- belongs_to :users
 
## categories テーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|path|string:index||
### Association
- has_many :items through: :item_categories
 
