class Users::RegistrationsController < Devise::RegistrationsController

  def respond_with(resource, _opts = {})
    if resource.persisted?
      register_success(resource)
    else
      register_failed
    end
  end

  private

  def register_success(resource)
    UserMailer.registration_confirmation(resource).deliver

    file_path = Rails.root.join('public', 'logo.png')
    if File.exist?(file_path)
      resource.avatar.attach(io: File.open(file_path), filename: 'logo.png')
      av = resource.avatar.attached? ? url_for(resource.avatar) : nil

      render json: {
        message: 'Signed up successfully.',
        user: resource,
        av: av,
        status: 200
      }, status: :ok
    else
      render json: { message: 'Avatar file does not exist.', status: 500 }, status: :internal_server_error
    end
  end

  def register_failed
    render json: { message: 'Something went wrong.' }, status: :unprocessable_entity
  end
end
