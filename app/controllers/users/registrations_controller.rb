
class Users::RegistrationsController < Devise::RegistrationsController


  def respond_with(resource, _opts = {})
    
    register_success && return if resource.persisted?

    register_failed

  end

  def register_success
   
  UserMailer.registration_confirmation(current_user).deliver 
  user = User.last.avatar.attach(io: File.open("#{Rails.root}/app/assets/images/logo.png"),filename: 'logo.png', content_type: 'image/png')
    render json: {
      message: 'Signed up sucessfully.',
      #user: current_user ,
     
      status: 200 ,
    }, status: :ok 
  end

  def register_failed
    render json: { message: 'Something went wrong.'  }
  end
  
  
end