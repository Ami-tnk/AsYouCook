require 'rails_helper'

RSpec.describe PostComment, 'PostCommentモデルのテスト', type: :model do

  let!(:user) { create(:user) }
  let!(:cook) { build(:cook, user_id: user.id) }

  describe 'バリデーションのテスト' do
    context '実際に保存してみる' do
      it '実際に保存してみる' do
        expect(FactoryBot.build(:post_comment)).to be_valid
      end
      it '空白の場合にバリデーションチェックされているか' do
        post_comment = FactoryBot.build(:post_comment)
        post_comment.comment = ''
        expect(post_comment.valid?).to eq false
      end
    end
  end
end