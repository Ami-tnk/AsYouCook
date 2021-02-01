require 'rails_helper'

RSpec.describe Cook, "Cookモデルに関するテスト", type: :model do
  describe 'バリデーションのテスト' do
    subject { cook.valid? }

    let(:user) { create(:user) }
    let!(:cook) { build(:cook, user_id: user.id) }

    context "cooking_nameカラム" do
      it "空白でないこと" do
        cook.cooking_name = ''
        is_expected.to eq false
      end
    end
  end
end