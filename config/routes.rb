Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homes#top'

  devise_for :users
  get   '/mypage' => 'users#mypage'
  get   'users/:nickname' => 'users#show'
  patch 'users/:nickname' => 'users#update'
  delete 'users/:nickname' => 'users#destroy', as: 'user_destroy'
  get   'users/:nickname/edit' => 'users#edit', as: 'user_nickname_edit'
  get   'all_users' => 'users#index'

  resources :cooks, only: [:index, :show, :create, :edit, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
end
