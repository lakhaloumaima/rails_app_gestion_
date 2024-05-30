Rails.application.routes.draw do

  devise_for :users,
            controllers: {
              sessions: 'users/sessions',
              registrations: 'users/registrations'


            }



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

  post 'addRequest' , to: 'request#create'

  post 'addReason' , to: 'reason#create'

  delete 'requests/:id' , to: 'request#destroyR'

  delete 'reasons/:id' , to: 'reason#destroyReason'


  patch 'requests/:id' , to: 'request#update'

  patch 'updateRequestByEmployee/:id' , to: 'request#updateRequestByEmployee'

  get 'getrequestacceptedbyemployee' , to: 'request#getrequestacceptedbyemployee'

  get 'getrequestinprogressbyemployee' , to: 'request#getrequestinprogressbyemployee'

  get 'getrequestrefusedbyemployee' , to: 'request#getrequestrefusedbyemployee'

  get 'getrequestdata/:id' , to: 'request#getrequestdata'

  get 'getRequestByEmail/:email' , to: 'request#getRequestByEmail'

  get 'getRequestsByIdAccepted/:user_id' , to: 'request#getRequestsByIDAccepted'


 # ##################################################  employees  ###############################################

  get 'getemployeedata/:id' , to: 'employee#getemployedata'

  patch 'updateimguser/:id' , to: 'employee#updateimageuser'

  patch 'updateuser/:id' , to: 'employee#updateuser'

  get 'employees' , to: 'employee#getAllEmployees'

  get 'users' , to: 'employee#getAllUsers'


  get 'countall' , to: 'employee#countAll'

  delete 'employees/:id' , to: 'employee#destroyE'

  post 'createEmployee' , to: 'employee#createEmployee'

  get 'getEmployeeByEmail/:email' , to: 'employee#getEmployeeByEmail'


  # ##################################################  members  ###############################################

  resources :password_resets

  root 'members#index'

  resources :messages

  get 'getMessagesByReceiverId/:receiver_id/:sender_id' , to: 'messages#getMessagesByReceiverId'

  get 'getMessagesBySenderId/:sender_id/:receiver_id' , to: 'messages#getMessagesBySenderId'

  resources :request do
    member do
      get 'export_pdf'
      post 'import_pdf'
      get 'export_certificate'
    end
  end

  resources :reason

  mount ActionCable.server => '/cable'


end
