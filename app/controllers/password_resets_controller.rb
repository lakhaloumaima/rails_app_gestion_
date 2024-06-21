class PasswordResetsController < ApplicationController

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_reset_password
      render json: { msg: "Email delivered!", status: :ok }
    else
      render json: { msg: "User not found", status: :not_found}
    end
  rescue => e
    render json: { msg: "Error occurred: #{e.message}" }, status: :internal_server_error
  end

  def edit
    @user = User.find_by_reset_password_token!(params[:id])
  end
  def update
    @user = User.find_by_reset_password_token!(params[:id])

    if @user.update(user_params)
      render json: "password link has been updated"
    else
      redirect_to 'http://localhost:4200'

      # redirect_to 'https://gestionfront.herokuapp.com/' , allow_other_host: true
    end
  end
  private

  def user_params
    params.permit(:password)
  end


end
