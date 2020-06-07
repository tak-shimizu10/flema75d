# README

## Users テーブル

| Column       | Type   | Options                  |
| ------------ | ------ | ------------------------ |
| nickname     | string | null: false, unique:true |
| email        | string | null: false, unique:true |
| password     | string | null: false, default""   |
| first_name   | string | null: false, default""   |
| last_name    | string | null: false, default""   |
| first_kana   | string | null: false, default""   |
| last_kana    | string | null: false, default""   |
| birthday     | date   | null: false              |
| phone_number | string |                          |
| image        | text   |                          |
| profile      | text   |                          |

### Association

- has_one  :address, dependent: :destroy
- has_many :items, dependent: :destroy
- has_many :cards, dependent: :destroy
- has_many :comments ,dependent: :destroy
- has_many :likes, dependent: :destroy
- has_many :addresses, dependent: :destroy
- has_many :cards, dependent: :destroy
- has_many :evaluates, dependent: :destroy
- has_many :sns_credentials, dependent: :destroy

## Address テーブル

| Column        | Type    | Options                |
| ------------- | ------- | ---------------------- |
| zipcode       | string  | null: false, default"" |
| prefecture_id | integer | null: false            |
| city          | string  | null: false, default"" |
| address       | string  | null: false, default"" |
| build_name    | string  |                        |
| user_id       | integer | foreign_key: true      |

### Association

- belongs_to :user, optional: true
- belongs_to_active_hash :prefecture

## Items テーブル

| Column        | Type    | Options                       |
| ------------- | ------- | ----------------------------- |
| name          | string  | null: false                   |
| detail        | text    | null: false                   |
| price         | integer | null: false                   |
| pay_side      | integer | enum, null: false             |
| post_date     | integer | enum, null: false             |
| status        | integer | enum, null: false             |
| situation     | integer | enum, null: false, default: 0 |
| post_way_id   | integer | null: false, default: 0       |
| prefecture_id | integer | null: false                   |
| category_id   | integer | foreign_key: true             |
| brand_id      | integer |                               |
| user_id       | integer | foreign_key: true             |
| buyer_id      | integer |                               |

### Association

- has_many :likes,dependent: :destroy
- has_many :images, dependent: :destroy
- has_many :comments, dependent: :destroy
- has_many :evaluates, dependent: :destroy
- belongs_to :category
- belongs_to :user
- belongs_to :brand, optional: true
- belongs_to_active_hash :prefecture
- belongs_to_active_hash :post_way

## Comments テーブル

| Column  | Type    | Options           |
| ------- | ------- | ----------------- |
| comment | text    | null: false       |
| user_id | integer | foreign_key: true |
| item_id | integer | foreign_key: true |

### Association

- belongs_to :user
- belongs_to :item

## Brands テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

### Association

- has_many :items

## Images テーブル

| Column  | Type    | Options           |
| ------- | ------- | ----------------- |
| image   | text    | null: false       |
| item_id | integer | foreign_key: true |

### Association

- belongs_to :item

## Likes テーブル

| Column  | Type    | Options           |
| ------- | ------- | ----------------- |
| user_id | integer | foreign_key: true |
| item_id | integer | foreign_key: true |

### Association

- belongs_to :item
- belongs_to :user

## Categories テーブル

| Column   | Type         | Options     |
| -------- | ------------ | ----------- |
| name     | string       | null: false |
| ancestry | string:index |             |

### Association

- has_many :items

## Cards テーブル

| Column      | Type    | Options                  |
| ----------- | ------- | ------------------------ |
| customer_id | string  | null: false              |
| card_id     | string  | null: false, unique:true |
| user_id     | integer | foreign_key:true         |

### Association

- belongs_to :user

## Evaluates テーブル

| Column      | Type    | Options     |
| ----------- | ------- | ----------- |
| evaluate_id | integer | null: false |
| user_id     | integer | null: false |
| item_id     | integer | null: false |
| rate        | integer | null: false |

### Association

- belongs_to :user
- belongs_to :item

## SnsCredentials テーブル

| Column   | Type       | Options          |
| -------- | ---------- | ---------------- |
| provider | string     | null: false      |
| uid      | string     | null: false      |
| user_id  | references | foreign_key:true |

### Association

- belongs_to :user, optional: true
