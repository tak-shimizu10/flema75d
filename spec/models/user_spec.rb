require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do

    it "nickname、first_name、last_name、first_kana、last_kana、email、password、password_confirmation、birthdayが存在すれば登録できること" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "nicknameがない場合は登録できないこと" do
      user = build(:user, nickname: nil)
      user.valid?
      expect(user.errors[:nickname]).to include("を入力してください")
    end

    it "emailがない場合は登録できないこと" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("を入力してください", "フォーマットが不適切です")
    end

    it "emailに@がない場合は登録できないこと " do
      user = build(:user, email: "aaaaaa")
      user.valid?
      expect(user.errors[:email]).to include("は不正な値です", "フォーマットが不適切です")
    end

    it "重複したemailが存在する場合登録できないこと" do
      user = create(:user)
      another_user = build(:user, email: user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include("はすでに存在します")
    end

    it "passwordがない場合は登録できないこと" do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("を入力してください", "は7文字以上で入力してください", "半角英数字で入力してください")
    end

    it "passwordが6文字以下であれば登録できないこと" do
      password = Faker::Internet.password(min_length: 6, max_length: 6)
      user = build(:user, password: password, password_confirmation: password)
      user.valid?
      expect(user.errors[:password]).to include("は7文字以上で入力してください", "半角英数字で入力してください")
    end

    it "passwordが7文字以上で、英数字の組み合わせであれば登録できること" do
      user = build(:user, password: "aBcD123", password_confirmation: "aBcD123")
      user.valid?
      expect(user).to be_valid
    end

    it "passwordが数字のみの場合は登録できないこと" do
      user = build(:user, password: "1234567", password_confirmation: "1234567")
      user.valid?
      expect(user.errors[:password]).to include("半角英数字で入力してください")
    end

    it "passwordが英文字のみの場合は登録できないこと" do
      user = build(:user, password: "aBcDeFg", password_confirmation: "aBcDeFg")
      user.valid?
      expect(user.errors[:password]).to include("半角英数字で入力してください")
    end

    it "passwordとpassword_confirmationが一致していない場合は登録できないこと" do
      user = build(:user, password: "abcd123", password_confirmation: "1234abc")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("とPasswordの入力が一致しません")
    end

    it "first_nameがない場合は登録できないこと" do
      user = build(:user, first_name: nil)
      user.valid?
      expect(user.errors[:first_name]).to include("を入力してください", "全角で入力してください")
    end

    it "last_nameがない場合は登録できないこと" do
      user = build(:user, last_name: nil)
      user.valid?
      expect(user.errors[:last_name]).to include("を入力してください", "全角で入力してください")
    end

    it "first_kanaがない場合は登録できないこと" do
      user = build(:user, first_kana: nil)
      user.valid?
      expect(user.errors[:first_kana]).to include("を入力してください", "全角カナで入力してください")
    end

    it "last_kanaがない場合は登録できないこと" do
      user = build(:user, last_kana: nil)
      user.valid?
      expect(user.errors[:last_kana]).to include("を入力してください", "全角カナで入力してください")
    end

    it "birthdayがない場合は登録できないこと" do
      user = build(:user, birthday: nil)
      user.valid?
      expect(user.errors[:birthday]).to include("を入力してください")
    end
  end

  describe '#ぜんかく' do

    it "first_nameが全角文字であれば登録できること" do
      user = build(:user, first_name: "ぜんかく")
      user.valid?
      expect(user).to be_valid
    end

    it "last_nameが全角文字であれば登録できること" do
      user = build(:user, last_name: "ぜんかく")
      user.valid?
      expect(user).to be_valid
    end

  end

  describe '#ゼンカクカナ' do

    it "first_kanaが全角カナ文字であれば登録できること" do
      user = build(:user, first_kana: "ゼンカクカナ")
      user.valid?
      expect(user).to be_valid
    end

    it "last_kanaが全角カナ文字であれば登録できること" do
      user = build(:user, last_kana: "ゼンカクカナ")
      user.valid?
      expect(user).to be_valid
    end

  end
end