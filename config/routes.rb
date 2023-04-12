Rails.application.routes.draw do
  use_doorkeeper
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :accounts, controllers: {
    registrations: 'accounts/registrations',
    sessions: 'accounts/sessions'

  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "hospitals#index"

  post ":ratable/:ratable_id/ratings", to: "ratings#create"
  get  ":ratable/:ratable_id/ratings", to:"ratings#index"
  get  "api/doctors/:id/ratings" , to:"api/doctors#showRating"
  get "api/hospitals/:id/ratings" , to:"api/hospitals#showRatings"
  get "api/doctors/:id/hospitals"  , to:"api/doctors#showHospitals"
  get "api/bill/:id/prescribtion" , to:"api/bill#showPresc"
  post "api/:ratable/:ratable_id/ratings", to: "api/ratings#create"
  get  "api/:ratable/:ratable_id/ratings", to:"api/ratings#index"
  get "api/bill" , to: "api/bill#index"


  resources :hospitals do
    post "/search" , to: "hospitals#search" , as: :search , on: :collection
    resources :doctors, shallow: true do
      post "/search"  , to: "doctors#search" , as: :search , on: :collection
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

  namespace :api , :defaults => {:format=> :json} do
    resources :patients do
      resources :appointments , shallow:true
    end
  end




  resources :hospitals do
    resources :ratings , shallow: true do
      get '/page/:page', action: :index, on: :collection
    end

  end



  namespace :api , :defaults => {:format=> :json} do
    resources :appointments do
      resources :prescribtions , shallow:true
    end
  end

  namespace :api , :defaults => {:format=> :json} do
    resources :prescribtions do
      resources :bill , shallow:true
    end
  end

  namespace :api , :defaults => {:format => :json} do
    resources :hospitals , only: [:index , :show ] do
      resources :doctors , shallow: true , only: [:index , :show , :create , :destroy , :update ] do
        resources :appointments ,  only: [:index , :show , :create , :destroy , :update ]
      end
    end
  end
  namespace :api , :defaults => {:format => :json} do
    resources :patients , only: [:index , :show , :update , :edit , :create]
  end
  namespace :api , :defaults => {:format => :json} do
    resources :patients , only: [:index , :show , :update , :edit , :destroy , :create] do
      resources :appointments , only: [:index , :show , :update , :edit , :destroy , :create]
    end

  end

  namespace :api , :defaults =>{:format => :json} do
    resources :doctors do
      resources :ratings , shallow: true , only: [:index , :show , :edit , :update , :destroy]
    end
  end


  namespace :api , :defaults =>{:format => :json} do
    resources :hospitals do
      resources :ratings , shallow: true , only: [:index , :show , :edit , :update , :destroy  ]
    end
  end

  put ":id/appointment", to: "appointments#decline" , as: :decline_appointment
end
