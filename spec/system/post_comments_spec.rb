require 'rails_helper'

describe 'コメント機能', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:cook) { create(:cook, user: user) }
  let!(:other_cook) { create(:cook, user: other_user) }
  #let!(:post_comment) {create(:post_comment, cook: cook, user: user)} # 3つ通る

  # let!(:other_post_comment) {create(:post_comment, cook: cook, user: other_user)}

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログインする'
    visit cook_path(cook)
  end

  context '料理詳細画面を表示した時' do
    let!(:post_comment) {create(:post_comment, cook: cook, user: user)} #!つけてもつけなくても2項目めコメントが表示されているがerror
    before { visit cook_path(cook) }

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
end