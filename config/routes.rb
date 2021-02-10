Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homes#top'

  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
  }

  get   '/mypage' => 'users#mypage', as: 'mypage'
  # constraintsで先頭が「/」以外のものは全て許すように設定（ex.ユーザー名「ami.T」と「.」使用も問題なく遷移）
  get   'users/:nickname' => 'users#show', constraints: { nickname: /[^\/]+/ }, as: 'user_nickname'
  get 'users/:nickname/edit' => 'users#edit', constraints:
    { nickname: /[^\/]+/ }, as: 'user_nickname_edit'
  patch 'users/:nickname' => 'users#update', constraints: { nickname: /[^\/]+/ }
  delete 'users/:id' => 'users#destroy', as: 'user_destroy'

  resources :cooks, only: [:index, :show, :create, :edit, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  delete 'notifications/destroy_all' => 'notifications#destroy_all', as: 'destroy_all_notification'
end
