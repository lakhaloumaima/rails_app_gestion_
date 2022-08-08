Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations' ,
               passwords: 'users/passwords'
               
              
             } 
  devise_scope :user do
    post "users/reset_password" => "users/registrations#reset_password", as: 'reset_password'
  end

  # devise_for :users, except: ['sessions#new' 'registrations#confirm_email']

  resources :employee , only: %i[ confirm_email] do
    member do
      get :confirm_email
    end
  end

  post 'auth' , to: 'auth#create'


  delete 'logout' , to: 'auth#destroy'

  # ##################################################  requests  ###############################################
  get 'requests' , to: 'request#index'
  
  get 'requests/:last_name' , to: 'request#getEmployeesByName'

  get 'getrequestsbyid/:user_id' , to: 'request#getRequestsByID'

  post 'requests' , to: 'request#create'

  delete 'requests/:id' , to: 'request#destroyR'

  patch 'requests/:id' , to: 'request#update'

  patch 'updateRequestByEmployee/:id' , to: 'request#updateRequestByEmployee'

  get 'getrequestacceptedbyemployee' , to: 'request#getrequestacceptedbyemployee'
  
  get 'getrequestinprogressbyemployee' , to: 'request#getrequestinprogressbyemployee'
  
  get 'getrequestrefusedbyemployee' , to: 'request#getrequestrefusedbyemployee'

  get 'getrequestdata/:id' , to: 'request#getrequestdata'

 # ##################################################  employees  ###############################################

  get 'getemployeedata/:id' , to: 'employee#getemployedata'

  patch 'updateimguser/:id' , to: 'employee#updateimageuser'

  patch 'updateuser/:id' , to: 'employee#updateuser'

  get 'employees' , to: 'employee#getAllEmployees'
  
  get 'countall' , to: 'employee#countAll'

  delete 'employees/:id' , to: 'employee#destroyE'


  post 'createEmployee' , to: 'employee#createEmployee'


  # ##################################################  members  ###############################################
  get '/member-data', to: 'members#show'
  root 'members#index'




  

end
