Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homes#top'

  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
  }

  get   '/mypage' => 'users#mypage'
  get   'users/:nickname' => 'users#show'
  patch 'users/:nickname' => 'users#update'
  delete 'users/:nickname' => 'users#destroy', as: 'user_destroy'
  get   'users/:nickname/edit' => 'users#edit', as: 'user_nickname_edit'

  resources :cooks, only: [:index, :show, :create, :edit, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  delete 'notifications/destroy_all' => 'notifications#destroy_all', as: 'destroy_all_notification'
end
