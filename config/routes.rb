Rails.application.routes.draw do
  use_doorkeeper
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :accounts, controllers: {
    registrations: 'accounts/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "hospitals#index"
  post ":ratable/:ratable_id/ratings", to: "ratings#create"
  get  ":ratable/:ratable_id/ratings", to:"ratings#index"
  get  "api/doctors/:id/ratings" , to:"api/doctors#showRating"
  get "api/hospitals/:id/ratings" , to:"api/hospitals#showRatings"
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

  namespace :api , :defaults => {:format=> :json} do
    resources :patients do
      resources :appointments , shallow:true
    end
  end




  resources :hospitals do
    resources :ratings , shallow: true
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
    resources :hospitals , only: [:index , :show , :update , :destroy , :create] do
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
      resources :ratings , shallow: true
    end
  end


  namespace :api , :defaults =>{:format => :json} do
    resources :hospitals do
      resources :ratings , shallow: true
    end
  end


end
