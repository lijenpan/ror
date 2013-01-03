ShoppingCenter::Application.routes.draw do

  #USER ROUTES
  devise_for :users, :controllers => {:unlocks => "unlocks"}

  resources :users, :except => [:index] do
    member do
      get 'become' => 'users#become', :as => :become
    end
  end

  User::ROLES.each do |r|
    match "#{r.to_s}/dashboard" => "#{r.to_s.pluralize}#dashboard", :as => "#{r.to_s}_dashboard"
    get "#{r.to_s}/:id" => "#{r.to_s.pluralize}#show", :as => r.to_s
    get "#{r.to_s}/:id/edit" => "users#edit", :role => r.to_s, :as => "edit_#{r.to_s}"
    put "#{r.to_s}/:id" => "users#update", :role => r.to_s
  end

  resources :research_groups

  #SHOPPING CENTER ROUTES
  resources :shopping_centers, :except => [:index] do
    resources :comments

    collection do
      get 'search'
    end

    member do
      get 'set_state' => 'shopping_centers#set_state', :as => :set_state
    end
  end
  get 'shopping_centers/:shopping_center_id/snapshot/:created_at' => 'snapshots#snapshot', as: :shopping_center_snapshot

  #RETAILER ROUTES
  resources :retailers, :except => [:index] do
    collection do
      get 'search'
    end

    member do
      get 'snapshot/:created_at' => 'snapshots#snapshot', :as => :snapshot
    end
  end
  get 'retailers/:retailer_id/snapshot/:created_at' => 'snapshots#snapshot', as: :retailer_snapshot

  #TASK ROUTES
  resources :tasks, :except => [:index] do
    resources :comments

    member do
      get 'set_state' => 'tasks#set_state', :as => :set_state
    end
  end

  #COVERAGE LIST ROUTES
  resources :coverage_lists, :except => [:index] do
    resources :coverage_policies, :except => [:index, :show]
    resources :coverage_tasks, :only => [:show] do
      get 'close' => 'coverage_tasks#close', as: :close
      get 'snooze' => 'coverage_tasks#snooze', as: :snooze
    end
  end

  ###################
  resources :messages, :only => [:destroy, :create, :new, :show]
  resources :bugs

  match "404" => "errors#error_404"
  match "500" => "errors#error_500"
  match 'home' => 'home#index', :as => :home
  match 'faq' => 'home#faq', :as => :faq
  match 'search' => 'home#search', :as => :search

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => redirect('/users/sign_in')

  #route to catch errors
  match '*not_found' => 'errors#error_404'
end
