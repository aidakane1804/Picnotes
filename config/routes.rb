Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/boards/:id/toggle_note' => 'boards#toggle_note', as: :toggle_board_note

  resources :notes do
    resources :tags, only: [:create, :destroy]
    resources :likes, shallow: true, only: [:create, :destroy]
    resources :dislikes, shallow: true, only: [:create, :destroy]
  end

  resource :session, only: [:new, :create, :destroy, :show, :index]
  resources :users, only: [:new, :create, :show] do
    resources :boards

  end

  resources :favorite_notes, only: [:create, :destroy]
  get '/favorites', to: 'favorite_notes#index', as: 'favorites'

  root 'notes#index'
end
