
class EmployeeController < ApplicationController
  #  before_action :authenticate_user!

  


  def updateuser
    @user = User.find(params[:id])

    if @user.update(post_paramsFreelancer)

      render json: @user 

    else
      render json: @user.errors, statut: :unprocessable_entity
    end
  end


  def updateimageuser
    user = User.find(params[:id])
    cover_url = rails_blob_path(current_user.avatar, disposition: "attachment")

    if @user.update(paramsimageuser)
      render json:   cover_url 
    

    else
      render json: @user.errors, statut: :unprocessable_entity
    end
  end

  private 

  def user_image_url
    avatar.attached? ? url_for(avatar) : nil
  end

  def paramsimageuser
    params.permit(:id, :avatar)
  end

  def post_paramsFreelancer
    params.permit( :email, :password, :address, :last_name, :first_name, :phone)
  end

end 