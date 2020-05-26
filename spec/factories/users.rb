FactoryBot.define do
  password = Faker::Internet.password(min_length: 7, max_length: 100)

  factory :user do
    nickname              { "yamada" }
    email                 { Faker::Internet.email }
    password              { password }
    password_confirmation { password }
    first_name            { "ぜんかく" }
    last_name             { "ぜんかく" }
    first_kana            { "ゼンカクカナ" }
    last_kana             { "ゼンカクカナ" }
    birthday              { "2020-01-01" }
  end
end
