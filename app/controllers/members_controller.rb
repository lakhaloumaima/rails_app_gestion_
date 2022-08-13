# app/controllers/members_controller.rb
class MembersController < ApplicationController
   # before_action :authenticate_user!
  
    def index 
      render json: {success: 'hello '} 
    end

  

  end