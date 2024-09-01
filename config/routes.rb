Rails.application.routes.draw do
  resources :card_likes
  resources :myedtools
  resources :edtrackers
  get 'password_resets/new'
  get 'password_resets/edit'
  post 'update_status', to: 'edtrackers#update_status'
  get 'fetch_model_form', to:'edtrackers#fetch_model_form'
  get 'fetch_model_form1', to:'myedtools#fetch_model_form1'
  get 'comment_section', to:'myedtools#comment_section'
  post 'create_ed_tool_comment', to:'myedtools#create_ed_tool_comment'
  post 'comment_delete_edtools', to:'myedtools#comment_delete_edtools'


  post 'card_liked' , to:'edtrackers#card_liked'
  delete 'card_liked_destroy' , to:'edtrackers#card_liked_destroy'
  post 'card_comment_likes' , to:'edtrackers#card_comment_likes'
  get 'comment_section_edtracker', to:'edtrackers#comment_section_edtracker'
  post 'create_comment', to:'edtrackers#create_comment'
  post 'comment_delete', to:'edtrackers#comment_delete'




  post 'card_likes_ed' , to:'myedtools#card_likes_ed'
  delete 'card_likes_destroy_ed' , to:'myedtools#card_likes_destroy_ed'
  post 'card_comment_likes_ed' , to:'myedtools#card_comment_likes_ed'


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/sitemap.xml.gz', to: redirect("http://s3-us-west-1.amazonaws.com/picnotes-2019/sitemaps/sitemap.xml.gz")

  post '/boards/:id/toggle_note' => 'boards#toggle_note', as: :toggle_board_note
  resources :notes do
    member do
      put 'like', to: 'notes#upvote'
      put 'dislike', to: 'notes#downvote'


    end
    collection do
      get 'chat_us', to:'chats#index'
      get 'community_interview', to: 'notes#community_interview'
      get 'contact_us', to: 'notes#contact_us'
      get 'freelance_research', to: 'notes#freelance_research'
      get 'educational_organizations', to: 'notes#educational_organizations'
      get 'what_is_picnotes', to: 'notes#what_is_picnotes'
      get 'message_from_the_founder', to: 'notes#message_from_the_founder'
      get 'sharing_your_knowledge', to: 'notes#sharing_your_knowledge'
      get 'optimizing_your_dashboard', to: 'notes#optimizing_your_dashboard'
      get 'what_type_of_topics_you_should_share', to: 'notes#what_type_of_topics_you_should_share'
      get 'communication_and_interaction', to: 'notes#communication_and_interaction'
      get 'contact_us_form', to: 'notes#contact_us_form'
      get 'add_note_to_folder', to: 'notes#add_note_to_folder'

    end
    resources :references, shallow: true, only: [:new, :create, :edit, :update, :destroy]
    resources :tags, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
    resources :dislikes, shallow: true, only: [:create, :destroy]
    post '/addfolder', to: 'notes#addfolder'
    post '/create_new_folder', to: 'notes#create_new_folder'
    post 'create_comment', on: :member
    post 'comment_delete', on: :member

  end
  get 'notes/:id/add_picnotes_to_folder', to: 'notes#add_picnotes_to_folder', as: 'add_picnotes_to_folder'
  get 'comment_section_note', to:'notes#comment_section_note'
  post 'card_liked' , to:'notes#card_liked'
  delete 'card_liked_destroy' , to:'notes#card_liked_destroy'
  post 'card_comment_likes' , to:'notes#card_comment_likes'







  

  get 'terms-and-conditions', to: 'home#terms_and_conditions'
  get 'privacy-policy', to: 'home#privacy_policy'
  get 'guidelines', to: 'notes#community_guideline'
  get 'about-us', to: 'notes#about_us'
  get 'tl', to: 'notes#tl'
  get 'migrate_notes', to: 'notes#migrate_notes'
  get 'for-schools',to: 'notes#for_schools'
  get 'edfluencers',to: 'ed_fluencers#index'

  # get 'terms_and_conditions', to: 'notes#terms_and_conditions', as: 'terms-and-conditions'
  resources :messages, only:[:create]
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
  resources :ed_fluencers, :except => [:index]

  resources :folders

  resources :tags, only: [:index, :show]

  get 'search/index'


  resources :feed, only: [:index] do
    collection do
      get :user_search
      get :feed_index
    end
  end

  resource :session, only: [:index, :new, :create, :destroy, :show] do
    collection do
      get :user_notes
    end
  end

  post 'followunfollow', to: 'relationships#ajaxfollowunfollow'

  resources :relationships

  resources :users do
    member do
      get :following, :followers
    end
    collection do
      get 'archived_user', to: 'users#archived_user'
    end
    resources :chats, only: [:index, :show, :create]
    resources :boards
  end
  resources :flashcard_sets do
    get 'new_field', on: :collection
  end
  get 'create_flashcard', to: 'flashcard_sets#create_flashcard'

  resources :favorite_notes, only: [:create, :destroy]
  get '/favorites', to: 'favorite_notes#index', as: 'favorites'

  

  root 'notes#index'
  get 'trending', to: 'home#trending'
  get 'index', to: 'home#index'
  get 'user_search', to: 'home#user_search'
  get '/index', to: 'note#home_pagination', as: 'home_pagination'
  get 'notes_by_tag', to: 'home#notes_by_tag'
  get 'explore', to: 'notes#explore'
  resources :password_resets, only: [:new, :create, :edit, :update]

  devise_for :users, controllers: { 
  omniauth_callbacks: 'users/omniauth_callbacks',
  sessions: 'users/sessions'
 }

end
