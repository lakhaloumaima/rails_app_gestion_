Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations' 
               
              
             } 

  # devise_for :users, except: ['sessions#new' 'registrations#confirm_email']

  resources :registrations, only: %i[ confirm_email] do
    member do
      get :confirm_email
    end
  end
 
  get '/member-data', to: 'members#show'

  get 'employees' , to: 'admin#getAllEmployees'
  
  get 'countall' , to: 'admin#countAll'

  delete 'employees/:id' , to: 'admin#destroy'

  post 'auth' , to: 'auth#create'

 # post 'createEmployee' , to: 'admin#create'

  delete 'logout' , to: 'auth#destroy'

  #   requests 
  get 'requests' , to: 'request#index'
  
  get 'requests/:last_name' , to: 'request#getEmployeesByName'

  get 'getrequestsbyid/:user_id' , to: 'request#getRequestsByID'

  post 'requests' , to: 'request#create'

  delete 'requests/:id' , to: 'request#destroy'

  patch 'requests/:id' , to: 'request#update'

  
  patch 'updateimguser/:id' , to: 'employee#updateimageuser'

  patch 'updateuser/:id' , to: 'employee#updateuser'

  root 'members#index'

  

end
