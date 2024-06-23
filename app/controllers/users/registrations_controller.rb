class Users::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)
    company = Company.create!(name: params[:user][:company][:name], subdomain: params[:user][:company][:subdomain], solde: params[:user][:company][:solde])

    resource.company_id = company.id

    resource.solde = company.solde

    if resource.save
      register_success(resource)
    else
      register_failed(resource)
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :company_id, :solde)
  end

  def register_success(resource)
    UserMailer.registration_confirmation(resource).deliver

    file_path = Rails.root.join('public', 'logo2.jpeg')
    if File.exist?(file_path)
      resource.avatar.attach(io: File.open(file_path), filename: 'logo2.jpeg')
      av = resource.avatar.attached? ? url_for(resource.avatar) : nil

      render json: {
        message: 'Signed up successfully.',
        user: resource,
        av: av
      }, status: :ok
    else
      render json: { message: 'Avatar file does not exist.' }, status: :internal_server_error
    end
  end

  def register_failed(resource)
    render json: { message: 'Something went wrong.', errors: resource.errors.full_messages }, status: :unprocessable_entity
  end
end
