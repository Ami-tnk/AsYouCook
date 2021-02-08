require 'rails_helper'

describe 'コメント機能', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:cook) { create(:cook, user: user) }
  let!(:other_cook) { create(:cook, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログインする'
    visit cook_path(other_cook)
  end

  context '他のユーザーの料理詳細画面を表示した時' do
    # post_commentを作成
    let!(:post_comment) {create(:post_comment, cook: other_cook, user: user)}
    # リロード（再度訪ねる）することでコメントが表示される
    before { visit cook_path(other_cook) }

    it 'コメント欄が表示されている' do
      expect(page).to have_content 'コメント'
    end
    it 'コメントが表示されている' do
      expect(page).to have_content post_comment.comment
    end
     it '自分のコメントには削除ボタンが表示されている' do
      expect(page).to have_content "削除"
    end
  end

  context '他のユーザーの料理詳細画面を表示した時' do
    let!(:other_post_comment) {create(:post_comment, cook: other_cook, user: other_user)}
    before { visit cook_path(other_cook) }

    it '他のユーザーのコメントには削除ボタンが表示されない' do
      expect(page).to have_no_content "削除"
    end
  end
end
