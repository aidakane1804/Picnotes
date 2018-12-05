Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/boards/:id/toggle_note' => 'boards#toggle_note', as: :toggle_board_note

  resources :notes do
    member do
      put 'like', to: 'notes#upvote'
      put 'dislike', to: 'notes#downvote'
    end
    resources :references, shallow: true, only: [:create, :destroy]
    resources :tags, only: [:create, :destroy]
    resources :likes, shallow: true, only: [:create, :destroy]
    resources :dislikes, shallow: true, only: [:create, :destroy]
  end

  resources :tags, only: [:index, :show]

  resource :session, only: [:new, :create, :destroy, :show, :index] do
    collection do
      get :user_notes
    end
  end

  resources :relationships

  resources :users do
    member do
      get :following, :follwers
    end
    resources :boards
  end

  resources :favorite_notes, only: [:create, :destroy]
  get '/favorites', to: 'favorite_notes#index', as: 'favorites'

  root 'notes#index'
end
