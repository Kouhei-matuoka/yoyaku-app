Rails.application.routes.draw do
  get 'offices/new'

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get 'login/', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get 'attend_employees'
      get 'attendances/one_month_apply'
      patch 'attendances/update_one_month_apply'
      patch 'attendances/confirmation_one_month_apply'
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    collection do
      post 'import'
      resources :offices
    end
    resources :attendances, only: :update 
  end
end