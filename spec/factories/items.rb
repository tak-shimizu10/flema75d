FactoryBot.define do
  factory :item do
    name           { "アイテム名" }
    detail         { "商品詳細コメント" }
    price          { 999 }
    situation      { 0 }
    pay_side       { 1 }
    post_date      { 1 }
    status         { 1 }
    post_way_id    { 1 }
    brand_id       { 1 }
    user_id        { 1 }
    prefecture_id  { 20 }
    category_id    { 100 }
  end
end
