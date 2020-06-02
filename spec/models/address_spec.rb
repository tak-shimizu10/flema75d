require 'rails_helper'

# RSpec.describe Address, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

RSpec.describe Address, type: :model do
  describe '#create' do

    it "zipcode、prefecture_id、city、addressが存在すれば登録できること" do
      address = build(:address)
      expect(address).to be_valid
    end

    it "zipcodeがない場合は登録できないこと" do
      address = build(:address, zipcode: nil)
      address.valid?
      expect(address.errors[:zipcode]).to include("を入力してください", "ハイフンを入れて半角数字で入力してください")
    end

    it "zipcodeは7桁でないと登録できないこと" do
      address = build(:address, zipcode: "1234-4567")
      address.valid?
      expect(address.errors[:zipcode]).to include("ハイフンを入れて半角数字で入力してください")
    end

    it "prefecture_idがない場合は登録できないこと" do
      address = build(:address, prefecture_id: nil)
      address.valid?
      expect(address.errors[:prefecture_id]).to include("を入力してください")
    end

    it "cityがない場合は登録できないこと" do
      address = build(:address, city: nil)
      address.valid?
      expect(address.errors[:city]).to include("を入力してください")
    end

    it "addressがない場合は登録できないこと" do
      address = build(:address, address: nil)
      address.valid?
      expect(address.errors[:address]).to include("を入力してください")
    end

  end
end