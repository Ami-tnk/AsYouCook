require 'rails_helper'

RSpec.describe Cook, "Cookモデルに関するテスト", type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let!(:cook) { build(:cook, user_id: user.id) }

    context "実際に保存してみる" do
      it "有効な投稿内容の場合は保存されるか" do
        expect(FactoryBot.build(:cook)).to be_valid
      end
    end

    context "cooking_nameカラム" do
      it "空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
        cook.cooking_name = ''
        expect(cook.valid?).to eq false
        expect(cook.errors[:cooking_name]).to include("を入力してください")
      end
    end

    context "recipeカラム" do
      it "空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
        cook.recipe = ''
        expect(cook.valid?).to eq false
        expect(cook.errors[:recipe]).to include("を入力してください")
      end
    end

    context "image_idカラム" do
      it "空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
        cook.image = ''
        expect(cook.valid?).to eq false
        expect(cook.errors[:image]).to include("を入力してください")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Cook.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'PostCommentモデルとの関係' do
      it 'N:1となっている' do
        expect(Cook.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end

    context 'Favoriteモデルとの関係' do
      it 'N:1となっている' do
        expect(Cook.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end

    context 'Notificationモデルとの関係' do
      it 'N:1となっている' do
        expect(Cook.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end
