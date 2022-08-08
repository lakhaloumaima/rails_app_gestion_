# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController

  respond_to :json

  private

  def respond_with(_resource, _opts = {})
   # cover_url = rails_blob_path(current_user.avatar, disposition: "attachment")
   #cover_url = rails_blob_path(current_user.avatar, disposition: "attachment")
  # user = current_user.last.avatar.attach(io: File.open("#{Rails.root}/app/assets/images/logo.png"),filename: 'logo.png', content_type: 'image/png')
    cover_url = rails_blob_path(current_user.avatar, disposition: "attachment")
    av =  current_user.avatar.attached? ? url_for(current_user.avatar) : nil

    render json: {
      message: 'You are logged in.',
      user: current_user ,
      role: current_user.role  ,
      id: current_user.id  ,
      avatar: cover_url ,
      avv: av  
    #  methods: [:user_image_url] 
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

  def destroy
    super do
      # Turbo requires redirects be :see_other (303); so override Devise default (302)
      return redirect_to after_sign_out_path_for(resource_name), status: :see_other, notice: I18n.t('devise.sessions.signed_out')
    end
  end


    




end