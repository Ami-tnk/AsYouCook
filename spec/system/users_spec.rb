require 'rails_helper'

describe 'ユーザーログイン機能', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:cook) { create(:cook, user: user) }
  let!(:other_cook) { create(:cook, user: other_user) }

  describe 'ユーザーログイン前のテスト' do
    context 'トップ画面にいる時' do
      before do
        visit root_path
      end
      it 'トップ画面がルートパス"/"であるか' do
        expect(current_path).to eq('/')
      end
      it 'みんなの料理リンクが表示されみんなの料理画面に遷移する' do
        expect(page).to have_link "", href: cooks_path
      end
      it '新規登録リンクが表示され新規登録画面に遷移する' do
        expect(page).to have_link "", href: new_user_registration_path
      end
      it 'ログインリンクが表示されログイン画面に遷移する' do
        expect(page).to have_link "", href: new_user_session_path
      end
      it '料理が表示されている' do
        expect(page).to have_content cook.cooking_name
      end
    end
  end

  describe 'ユーザー新規登録のテスト' do
    before do
      visit new_user_registration_path
    end
    context '画面を表示した時' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規アカウントの作成」と表示される' do
        expect(page).to have_content '新規アカウントの作成'
      end
      it 'ニックネームフォームが表示される' do
        expect(page).to have_field 'user[nickname]'
      end
      it 'メールアドレスフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it '確認用パスワードフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録する'
      end
    end
    context '新規登録した時' do
      before do
        fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 3)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end
      it '正しく登録される' do
        expect { click_button '登録する' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先がmypage画面になっている' do
        click_button '登録する'
        expect(current_path).to eq '/mypage'
      end
    end
  end

  describe 'ユーザーログインのテスト' do
    before do
      visit new_user_session_path
    end
    context '画面を表示した時' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「アカウントをお持ちの方」と表示される' do
        expect(page).to have_content 'アカウントをお持ちの方'
      end
      it 'メールアドレスフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログインする'
      end
    end
    context 'ログインした時' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: 'password'
        click_button 'ログインする'
      end
      it 'ログイン後のリダイレクト先がmypage画面になっている' do
        expect(current_path).to eq '/mypage'
      end
    end
  end

  describe 'マイページ画面のテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログインする'
    end
    context '画面を表示した時' do
      it 'お知らせ画面が表示される' do
        expect(page).to have_content 'お知らせ'
      end
      it '新規投稿画面が表示される' do
        expect(page).to have_content '投稿'
      end
      it '自分の投稿料理画面が表示される' do
        expect(page).to have_content '料理一覧'
      end
      it 'お気に入り料理画面が表示される' do
        expect(page).to have_content 'お気に入り料理一覧'
      end
    end
  end

  describe 'ユーザーの編集画面のテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'password'
      click_button 'ログインする'
      visit "/users/#{user.nickname}/edit"
    end
    context '画面を表示した時' do
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'ニックネーム', with: user.nickname
      end
      it 'プロフィール画像フォームが表示される' do
        expect(page).to have_field '画像'
      end
      it '自己紹介フォームが表示される' do
        expect(page).to have_field '自己紹介'
      end
      it '編集するボタンが表示される' do
        expect(page).to have_button '編集する'
      end
      it '退会するボタンが表示される' do
        expect(page).to have_content '退会する'
      end
    end
    context '編集する時' do
      it '編集後リダイレクト先がmypage画面になり、フラッシュメッセージが表示される' do
        fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 5)
        click_button '編集する'
        expect(current_path).to eq '/mypage'
        expect(page).to have_content "編集しました"
      end
    end
    context '退会する時' do
      it 'ユーザーが削除される' do
        expect { user.destroy }.to change(User, :count).by(-1)
      end
    end
  end

  describe 'ユーザーの詳細画面のテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'password'
      click_button 'ログインする'
      visit "/users/#{other_user.nickname}"
    end
    context '画面を表示した時' do
      it '他のユーザー情報が表示されている' do
        expect(page).to have_content other_user.nickname
        expect(page).to have_content '自己紹介'
      end
      it '他のユーザーの投稿料理が表示されている' do
        expect(page).to have_content truncate(other_cook.cooking_name, length: 7)
      end
    end
  end

  describe 'ユーザーログアウトのテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'password'
      click_button 'ログインする'
    end
    context 'ログアウト機能のテスト' do
      it '正しくログアウトされ、新規登録リンクが表示されている' do
        click_link 'ログアウト'
        expect(page).to have_link '', href: new_user_registration_path
      end
      it 'リダイレクト先がトップ画面になっている' do
        click_link 'ログアウト'
        expect(current_path).to eq('/')
      end
    end
  end
end
