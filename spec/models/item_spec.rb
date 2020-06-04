require "rails_helper"

RSpec.describe Item, type: :model do

  describe "#create" do
    
    it "全ての項目が存在すれば登録できること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      expect(item).to be_valid
    end

    it "name(商品名)が存在しなければ登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, name: nil, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:name]).to include("を入力してください")
    end

    it "name(商品名)が４0文字以内だと登録できること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, name: "a" * 40, category_id: category.id, user_id: user.id)
      expect(item).to be_valid
    end
    
    it "name(商品名)が４1文字以上だと登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, name: "a" * 41, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:name]).to include("は40文字以内で入力してください")
    end
    
    it "detail(商品説明)が存在しなければ登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, detail: nil, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:detail]).to include("を入力してください")
    end

    it "detail(商品説明)が1000文字以内だと登録できること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, detail: "a" * 1000, category_id: category.id, user_id: user.id)
      expect(item).to be_valid
    end

    it "detail(商品説明)が1001文字以上だと登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, detail: "a" * 1001, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:detail]).to include("は1000文字以内で入力してください")
    end

    it "price(価格)が存在しなければ登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, price: nil, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:price]).to include("を入力してください")
    end
    
    it "price(価格)300以上ならば登録できること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, price: 300, category_id: category.id, user_id: user.id)
      expect(item).to be_valid
    end
    
    it "price(価格)9999999以下なら登録できること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, price: "9"*7, category_id: category.id, user_id: user.id)
      expect(item).to be_valid
    end
    
    it "price(価格)300以上でなければ登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, price: 299, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:price]).to include("は300以上の値にしてください")
    end
    
    it "price(価格)9999999以下でなければ登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, price: 10000000, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:price]).to include("は10000000より小さい値にしてください")
    end
    
    it "pay_side(送料負担)が存在しなければ登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, pay_side: nil, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:pay_side]).to include("を入力してください")
    end

    it "post_date(発送までの日数)が存在しなければ登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, post_date: nil, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:post_date]).to include("を入力してください")
    end

    it "status(商品の状態)が存在しなければ登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, status: nil, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:status]).to include("を入力してください")
    end

    it "post_way_id(配送方法)が存在しなければ登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, post_way_id: nil, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:post_way_id]).to include("を入力してください")
    end

    it "brand_id(ブランド)が存在しなくても登録できること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, brand_id: "", category_id: category.id, user_id: user.id)
      expect(item).to be_valid
    end

    it "brand_id(ブランド)が存在しても登録できること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, brand_id: 1, category_id: category.id, user_id: user.id)
      expect(item).to be_valid
    end

    it "category_id(カテゴリー)が存在しなければ登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: nil, user_id: user.id)
      item.valid?
      expect(item.errors[:category_id]).to include("を入力してください")
    end

    it "situation(商品の出品状態)が存在しなければ登録できないこと" do
      user = create(:user)
      category = create(:category)
      item = build(:item, situation: nil, category_id: category.id, user_id: user.id)
      item.valid?
      expect(item.errors[:situation]).to include("を入力してください")
    end

  end
  
  describe "#update" do
    
    it "全ての要素の更新ができること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      item.save(name: "更新", detail: "更新する", price: 9999, situation: 0, pay_side: 2, post_date: 2, status: 2, post_way_id: 2, brand_id: 2, prefecture_id: 22, category_id: 222)
      expect(item).to be_valid
    end

    it "name(名前)の更新ができること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      item.save(name: "更新")
      expect(item).to be_valid
    end
    
    it "detail(商品説明の更新ができること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      item.save(detail: "更新する")
      expect(item).to be_valid
    end
    
    it "price(価格)の更新ができること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      item.save(price: 9999)
      expect(item).to be_valid
    end
    
    it "pay_side(送料負担)更新ができること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      item.save(pay_side: 2)
      expect(item).to be_valid
    end
    
    it "post_date(配送日数)の更新ができること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      item.save(post_date: 2)
      expect(item).to be_valid
    end

    it "post_way_id(配送方法)の更新ができること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      item.save(post_way_id: 2)
      expect(item).to be_valid
    end
    
    it "prefecture_id(配送場所)の更新ができること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      item.save(prefecture_id: 2)
      expect(item).to be_valid
    end

    it "category_id(カテゴリー)の更新ができること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      item.save(category_id: 2)
      expect(item).to be_valid
    end

    it "brand_id(ブランド)の更新ができること" do
      user = create(:user)
      category = create(:category)
      item = build(:item, category_id: category.id, user_id: user.id)
      item.save(brand_id: 2)
      expect(item).to be_valid
    end
  end

end