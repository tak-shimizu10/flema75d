require "rails_helper"

RSpec.describe Item, type: :model do

  describe "#create" do

    it "name, detail, price, pay_side, post_date, status, prefecture_id,  category_id, situationが存在すれば登録できること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      expect(item).to be_valid
    end

    it
  end
end
