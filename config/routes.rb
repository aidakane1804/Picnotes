Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/boards/:id/toggle_note' => 'boards#toggle_note', as: :toggle_board_note

  resources :notes do
    member do
      put 'like', to: 'notes#upvote'
      put 'dislike', to: 'notes#downvote'
    end
    resources :references, shallow: true, only: [:new, :create, :edit, :update, :destroy]
    resources :tags, only: [:create, :destroy]
    resources :likes, shallow: true, only: [:create, :destroy]
    resources :dislikes, shallow: true, only: [:create, :destroy]
    post '/addfolder', to: 'notes#addfolder'
  end


  resources :folders

  resources :tags, only: [:index, :show]

  get 'search/index'

  resources :feed, only: [:index]

  resource :session, only: [:index, :new, :create, :destroy, :show] do
    collection do
      get :user_notes
    end
  end

  resources :relationships

  resources :users do
    member do
      get :following, :followers
    end
    resources :boards
  end

  resources :favorite_notes, only: [:create, :destroy]
  get '/favorites', to: 'favorite_notes#index', as: 'favorites'

  root 'notes#index'

  resources :password_resets, only: [:new, :create, :edit, :update]

  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end
