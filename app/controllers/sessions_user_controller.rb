class SessionsUserController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])

    if user&.valid_password?(session_params[:password])
      token = encode_token(user_id: user.id, email: user.email)
      session[:user_id] = user.id
      render json: { status: :ok, token: token, user: user }
    else
      render json: { status: :unauthorized, error: 'Invalid email or password' }
    end
  end

  private

  def session_params
    params.permit(:email, :password)
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.jwt_secret_key, 'HS256')
  end
end
