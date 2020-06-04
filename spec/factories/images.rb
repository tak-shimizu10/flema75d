FactoryBot.define do
  factory :image do
    image { File.join(Rails.root, "spec/factories/test_image/shirt-pci.jpg") }
    item_id { 1 }
  end
end
