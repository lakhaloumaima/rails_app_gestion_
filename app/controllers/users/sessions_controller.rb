# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController

  private

  def respond_with(_resource, _opts = {})

    cover_url = rails_blob_path(current_user.avatar, disposition: "attachment")
    av =  current_user.avatar.attached? ? url_for(current_user.avatar) : nil

    render json: {
      message: 'You are logged in.',
      user: current_user ,
      role: current_user.role  ,
      id: current_user.id  ,
      avatar: cover_url ,
      avv: av  

    }
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end

  def log_out_success
    render json: { message: 'You are logged out.' }, status: :ok
  end

  def log_out_failure
    render json: { message: 'Hmm nothing happened.' }, status: :unauthorized
  end


    




end