FactoryBot.define do
  factory :image do
    image { FIle.open("#{Rails.root}/spec/fictures/test_image.png") }
  end
end
