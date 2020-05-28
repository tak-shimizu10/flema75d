require "rails_helper"

RSpec.describe Item, type: :model do

  describe "#create" do

    it "全ての項目が存在すれば登録できること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      expect(item).to be_valid
    end

    # it "name(商品名)が存在しなければ登録できないこと" do
      
    # end

  end
end
