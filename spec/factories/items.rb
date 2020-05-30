FactoryBot.define do
  factory :item do
    name           { "アイテム名" }
    detail         { "商品詳細コメント" }
    price          { 999 }
    situation      { 0 }
    user_id        { 1 }
    pay_side       { 2 }
    post_date      { 3 }
    status         { 4 }
    prefecture_id  { 5 }
    category_id    { 6 }
    post_way_id    { 7 }
    brand_id       { 1 }
  end
end
