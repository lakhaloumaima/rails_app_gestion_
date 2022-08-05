# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(_resource, _opts = {})
    cover_url = rails_blob_path(current_user.avatar, disposition: "attachment")
    render json: {
      message: 'You are logged in.',
      user: current_user ,
      role: current_user.role  ,
      id: current_user.id  ,
      avatar: cover_url 
    #  methods: [:user_image_url] 
    }, status: :ok  
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