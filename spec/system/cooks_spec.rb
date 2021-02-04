require 'rails_helper'

describe '料理投稿機能', type: :system do

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:cook) { create(:cook, user: user) }
  let!(:other_cook) { create(:cook, user: other_user) }

  describe 'みんなの料理(一覧表示機能)のテスト' do
    context 'userがログインしていない時' do
      before do
        visit cooks_path  #indexpageに遷移
      end

      it 'URLが正しいこと' do
        expect(current_path).to eq '/cooks'
      end
      it '公開ステータス:trueの投稿が表示される' do
        expect(cook.is_active).to eq true
      end
      it '自分の投稿と他人の投稿の投稿が表示される' do
        expect(page).to have_content cook.user.nickname
        expect(page).to have_content other_cook.user.nickname
      end
    end

    context 'userがログインしている時' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログインする'
        visit cooks_path
      end

      it 'URLが正しいこと' do
        expect(current_path).to eq '/cooks'
      end
      it '公開ステータス:trueの投稿が表示される' do
        expect(cook.is_active).to eq true
      end
      it '自分の投稿と他人の投稿の投稿が表示される' do
        expect(page).to have_content cook.user.nickname
        expect(page).to have_content other_cook.user.nickname
      end
    end
  end

    describe '新規投稿した時のテスト' do
    context '投稿した時' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログインする'
        visit mypage_path
      end

      it '自分の新しい投稿が正しく保存される' do
        attach_file 'cook[image]', "spec/fixtures/test.jpg"
        fill_in 'cook[cooking_name]', with: cook.cooking_name
        fill_in 'cook[recipe]', with: cook.recipe
        click_button '保存'
        expect(page).to have_content "料理を投稿しました!"
      end
      it '投稿に失敗しエラーメッセージ が表示されるか' do
        click_button '保存'
        expect(page).to have_content 'エラー'
      end
      it '投稿後のリダイレクト先がmypageになっている' do
        attach_file 'cook[image]', "spec/fixtures/test.jpg"
        fill_in 'cook[cooking_name]', with: cook.cooking_name
        fill_in 'cook[recipe]', with: cook.recipe
        click_button '保存'
        expect(current_path).to eq '/mypage'
      end
    end
  end

  describe '料理詳細画面のテスト' do
    context 'userがログインしていない時' do
      before do
        visit cook_path(cook)
      end

      it 'URLが正しい'do
        expect(current_path).to eq '/cooks/' + cook.id.to_s
      end
      it '投稿料理名が表示されている' do
        expect(page).to have_content cook.cooking_name
      end
      it '投稿レシピが表示されている' do
        expect(page).to have_content cook.recipe
      end
      it '作成ユーザー名がリンク表示されている' do
        expect(page).to have_content cook.user.nickname
      end
      it '投稿の編集リンクが表示されない' do
        expect(page).to have_no_content '編集'
      end
      it '投稿の削除リンクが表示されない' do
        expect(page).to have_no_content '削除'
      end
    end

    context 'ログインユーザーの投稿料理詳細画面の時' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログインする'
        visit cook_path(cook)
        cook.user_id == user.id
      end

      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '編集', href: edit_cook_path(cook)
      end
      it '投稿の削除リンクが表示される、問題なく削除される' do
        expect(page).to have_link '削除', href: cook_path(cook)
      end
      it '投稿が削除される' do
        expect{ cook.destroy }.to change{ Cook.count }.by(-1)
      end
    end
  end

  describe '料理編集画面のテスト' do
    context '画面を表示した時' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログインする'
        visit cook_path(cook)
        cook.user_id = user.id
        visit edit_cook_path(cook)
      end
      it 'URLが正しい'do
        expect(current_path).to eq '/cooks/' + cook.id.to_s + '/edit'
      end
      it '編集前の料理名とレシピがフォームに表示されている' do
      expect(page).to have_field 'cook[cooking_name]', with: cook.cooking_name
      expect(page).to have_field 'cook[recipe]', with: cook.recipe
      end
      it '編集ボタンが表示される' do
        expect(page).to have_button '保存'
      end
      it '戻るボタンが表示される' do
        expect(page).to have_link '戻る', href: cook_path(cook)
      end
    end

    context '更新処理に関するテスト' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログインする'
        visit cook_path(cook)
        cook.user_id = user.id
        visit edit_cook_path(cook)
      end
      it '更新に成功しサクセスメッセージが表示されるか' do
        fill_in 'cook[cooking_name]', with: Faker::Lorem.characters(number:8)
        fill_in 'cook[recipe]', with: Faker::Lorem.characters(number:30)
        click_button '保存'
        expect(page).to have_content '料理を編集しました!'
      end
      it '更新に失敗しエラーメッセージが表示されるか' do
        fill_in 'cook[cooking_name]', with: ""
        fill_in 'cook[recipe]', with: ""
        click_button '保存'
        expect(page).to have_content 'エラー'
      end
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'cook[cooking_name]', with: Faker::Lorem.characters(number:8)
        fill_in 'cook[recipe]', with: Faker::Lorem.characters(number:30)
        click_button '保存'
        expect(page).to have_current_path cook_path(cook)
	    end
    end
  end
end
