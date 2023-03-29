Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :accounts, controllers: {
    registrations: 'accounts/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "hospitals#index"
  post ":ratable/:ratable_id/ratings", to: "ratings#create"
  get  ":ratable/:ratable_id/ratings", to:"ratings#index"
  resources :hospitals do
    resources :doctors, shallow: true do
      resources :ratings , shallow:true
    end
  end
  resources :patients do
    resources :appointments , shallow: true
  end

  resources :doctors do
    resources :appointments , shallow: true
  end
  post "doctors/:doctor_id/appointments/book", to: "appointments#book", as: :book_appointment

  resources :appointments do
    resources :prescribtions , shallow:true

  end

  resources :prescribtions do
    resources :bill
  end


  resources :hospitals do
    resources :ratings , shallow: true
  end

  namespace :api , :defaults => {:format => :json} do
    resources :hospitals , only: [:index , :show] do
      resources :doctors , shallow: true , only: [:index , :show ]
    end
  end
  namespace :api , :defaults => {:format => :json} do
    resources :patients , only: [:index , :show , :update , :edit , :create]
  end



end
