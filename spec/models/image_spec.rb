require 'rails_helper'

RSpec.describe Image, type: :model do
    describe "#create" do
      it "画像が存在すれば登録できること"do
      user = create(:user)
      category = create(:category)
      item =  build(:item, category_id: category.id, user_id: user.id)
      image = build(:image, item_id: item.id)
      expect(item).to be_valid
      end
      it "画像が存在しなければ登録できないこと" do
        user = create(:user)
        category = create(:category)
        item =  build(:item, category_id: category.id, user_id: user.id)
        image = build(:image, image: nil, item_id: item.id)
        image.valid?
        expect(image.errors[:image]).to include("を入力してください")
      end
end
