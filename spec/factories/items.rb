FactoryBot.define do
  factory :item do
    name           { "アイテム名" }
    detail         { "商品詳細コメント" }
    price          { 999 }
    pay_side       { 1 }
    post_date      { 1 }
    status         { 1 }
    prefecture_id  { 1 }
    category_id    { 1 }
    situation      { 0 }
    user_id        { 1 }
  end
end
