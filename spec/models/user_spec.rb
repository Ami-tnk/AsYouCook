require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let!(:other_user) { create(:user) }
    let!(:user) { create(:user) }

    context 'nicknameカラム' do
      it '空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか' do
        user.nickname = ''
        expect(user.valid?).to eq false
        expect(user.errors[:nickname]).to include("を入力してください")
      end

      it '一意性があり、エラーメッセージが返ってきているか' do
        user.nickname = other_user.nickname
        expect(user.valid?).to eq false
        expect(user.errors[:nickname]).to include("はすでに存在します")
      end
    end

    context 'emailカラム' do
      it '空白の場合バリデーションチェックされ空白のエラーメッセージが返ってきているか' do
        user.email = ''
        expect(user.valid?).to eq false
        expect(user.errors[:email]).to include("を入力してください")
      end

      it '一意性があり、エラーメッセージが返ってきているか' do
        user.email = other_user.email
        expect(user.valid?).to eq false
        expect(user.errors[:email]).to include("はすでに存在します")
      end
    end

    context 'passwordカラム' do
      it '空白の場合バリデーションチェックされ空白のエラーメッセージが返ってきているか' do
        user.password = ''
        expect(user.valid?).to eq false
        expect(user.errors[:password]).to include("を入力してください")
      end
    end
  end

  # アソシエーションのテストはRailsがやってくれていることなのであまりテストしない
  describe 'アソシエーションのテスト' do
    context 'Cookモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:cooks).macro).to eq :has_many
      end
    end

    context 'PostCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end

    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
  end
end
