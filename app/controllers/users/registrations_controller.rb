# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})

  #  UserMailer.registration_confirmation(resource).deliver
  
    register_success && return if resource.persisted?

    register_failed

  end

  def register_success
   
    user = User.last.avatar.attach(io: File.open("#{Rails.root}/app/assets/images/logo.png"),filename: 'default.jpeg', content_type: 'image/jpeg')
    
    render json: {
      message: 'Signed up sucessfully.',
      #user: current_user ,
     
      status: 200 ,
    }, status: :ok 
  end

  def register_failed
    render json: { message: 'Something went wrong.' }, status: :unprocessable_entity
  end
  
end