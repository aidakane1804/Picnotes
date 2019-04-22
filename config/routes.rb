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
    collection do
      get 'chat_us', to:'chats#index'
      get 'terms_and_conditions', to: 'notes#terms_and_conditions'
      get 'about_us', to: 'notes#about_us'
      get 'contact_us', to: 'notes#contact_us'
      get 'community_guideline', to: 'notes#community_guideline'
      get 'freelance_research', to: 'notes#freelance_research'
      get 'educational_organizations', to: 'notes#educational_organizations'
      get 'what_is_picnotes', to: 'notes#what_is_picnotes'
      get 'message_from_the_founder', to: 'notes#message_from_the_founder'
      get 'sharing_your_knowledge', to: 'notes#sharing_your_knowledge'
      get 'optimizing_your_dashboard', to: 'notes#optimizing_your_dashboard'
      get 'what_type_of_topics_you_should_share', to: 'notes#what_type_of_topics_you_should_share'
      get 'communication_and_interaction', to: 'notes#communication_and_interaction'
      get 'contact_us_form', to: 'notes#contact_us_form'

    end
    resources :references, shallow: true, only: [:new, :create, :edit, :update, :destroy]
    resources :tags, only: [:create, :destroy]
    resources :likes, shallow: true, only: [:create, :destroy]
    resources :dislikes, shallow: true, only: [:create, :destroy]
    post '/addfolder', to: 'notes#addfolder'
  end
  resources :messages, only:[:create]
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

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
    resources :chats, only: [:index, :show, :create]
    resources :boards
  end

  resources :favorite_notes, only: [:create, :destroy]
  get '/favorites', to: 'favorite_notes#index', as: 'favorites'

  root 'notes#index'

  resources :password_resets, only: [:new, :create, :edit, :update]

  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end
