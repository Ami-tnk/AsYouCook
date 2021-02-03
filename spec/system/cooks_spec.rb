require 'rails_helper'

describe '料理投稿機能' do, type: :system do
  describe 'みんなの料理(一覧表示機能)のテスト' do
    before do
      user_a = FactoryBot.create(:user, nickname: 'A', email: 'a@a')
      FacroyrBot.create(:cook, cooking_name: '餃子',recipe: 'test', image: 'test.jpg', user: user_a )
      #indexpageに遷移しておく
      visit cooks_path
    end

    context '内容を表示させた時' do
      it 'URLが正しいこと' do
        expect(current_path).to eq '/cooks'
      end
      it '自分の投稿と他人の投稿が表示される' do
        
      end
    end
  end

  describe '新規投稿した時のテスト' do
    before do
      #ユーザー作成
      #投稿内容作成
    end
    context '投稿した時' do
      it '投稿画像が正しく表示される' do
      end
      it '料理名が正しく表示される' do
      end
      it 'レシピが正しく表示される' do
      end
      it 'リダイレクト先がmypageになっている'do
      end
    end
  end
end