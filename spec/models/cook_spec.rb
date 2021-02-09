require 'rails_helper'

RSpec.describe 'Cookモデルに関するテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let!(:cook) { build(:cook, user_id: user.id) }

    context '実際に保存してみる' do
      it '有効な投稿内容の場合は保存されるか' do
        expect(FactoryBot.build(:cook)).to be_valid
      end
    end

    context 'cooking_nameカラム' do
      it '空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか' do
        cook.cooking_name = ''
        expect(cook.valid?).to eq false
        expect(cook.errors[:cooking_name]).to include("を入力してください")
      end
    end

    context 'recipeカラム' do
      it '空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか' do
        cook.recipe = ''
        expect(cook.valid?).to eq false
        expect(cook.errors[:recipe]).to include("を入力してください")
      end
    end

    context 'image_idカラム' do
      it '空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか' do
        cook.image = ''
        expect(cook.valid?).to eq false
        expect(cook.errors[:image]).to include("を入力してください")
      end
    end
  end

  # アソシエーションのテストはRailsがやってくれていることなのであまりテストしない
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Cook.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'PostCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Cook.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end

    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(Cook.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end

    context 'Notificationモデルとの関係' do
      it '1となっている' do
        expect(Cook.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end

  describe 'favorited_by?(user)メソッドのテスト' do
    let(:cook) { create(:cook) }
    let(:user) { create(:user) }

    context 'userが「いいね」した時' do
      let!(:favorite) { create(:favorite, user: user, cook: cook) }

      it 'userが「いいね」している(trueが返る)こと' do
        expect(cook.favorited_by?(user)).to eq true
      end
    end

    context 'userがいいねしていない時' do
      it 'userが「いいね」していない(falseが返る)こと' do
        expect(cook.favorited_by?(user)).to eq false
      end
    end
  end

  describe 'create_notification_favorite!(current_user)メソッドのテスト' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:cook) { create(:cook, user: user) }

    context '「いいね」をされた料理が自分の料理の時' do
      it '他のユーザーに「いいね」をされたら通知が1増えること' do
        expect { cook.create_notification_favorite!(other_user) }.
          to change { user.passive_notifications.count }.by(1)
      end
      it '料理投稿したユーザーが自分で「いいね」をしたら通知が増えないこと' do
        expect { cook.create_notification_favorite!(user) }.
          to change { user.passive_notifications.count }.by(0)
      end
    end
  end

  describe 'create_notification_post_comment!(current_user, post_comment_id)メソッドのテスト' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:cook) { create(:cook, user: user) }
    let(:post_comment) { create(:post_comment, cook: cook, user: user) }

    context '自分の料理にコメントされた時' do
      it 'コメントをされたら料理を投稿したユーザーに通知が1増えること' do
        expect { cook.create_notification_post_comment!(other_user, post_comment) }.
          to change { user.passive_notifications.count }.by(1)
      end
    end
  end
end
