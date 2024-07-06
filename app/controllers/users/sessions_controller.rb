class Users::SessionsController < Devise::SessionsController
  def respond_with(resource, _opts = {})
    if current_user
      session[:user_id] = current_user.id
      av = current_user.avatar.attached? ? url_for(current_user.avatar) : nil

      render json: {
        message: 'You are logged in.',
        user: current_user,
        role: current_user.role,
        id: current_user.id,
        avv: av,
        status: 200,
        subdomain: current_user.company.subdomain,
        redirect_url: subdomain_url(current_user.company.subdomain)
      }, include: [:company] , status: :ok
    else
      render json: { status: 401 }
    end
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

  private

  def subdomain_url(subdomain)
    "http://#{subdomain}.localhost:4200"
  end
end
