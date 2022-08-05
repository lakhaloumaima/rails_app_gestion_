# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  after_action :confirm_email

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_confirmed = true
      user.confirm_token = nil
      user.save
      redirect_to 'http://localhost:4200/'


    else
      
      render json: { status: 500 }

    end

  end

  private

  def respond_with(resource, _opts = {})

    UserMailer.registration_confirmation(resource).deliver
  
    register_success && return if resource.persisted?

    register_failed

  end

  def register_success
   
    user = User.last.avatar.attach(io: File.open("#{Rails.root}/app/assets/images/default.jpeg"),filename: 'default.jpeg', content_type: 'image/jpeg')
    
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