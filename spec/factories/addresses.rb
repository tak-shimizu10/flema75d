FactoryBot.define do
  factory :address do
    zipcode               { "123-4567" }
    prefecture_id         { 1 }
    city                  { "大阪市北区" }
    address               { "中崎3-1" }
  end
end
