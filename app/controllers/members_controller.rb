# app/controllers/members_controller.rb
class MembersController < ApplicationController
   # before_action :authenticate_user!

  def index
    render json: {success: 'hello '}
  end

  # create admin
  def createAdmin
    admin = User.new(admin_params.merge( role: 0 ))

    if admin.save
      render json: { status: :created, admin: admin }
    else
      render json: { status: :unprocessable_entity, errors: admin.errors.full_messages }
    end
  end

  # create employee
  def createEmployee
    @current_user = User.find(session[:user_id])

    if @current_user.role == 0
      employee = User.new( employee_params.merge( role: 1 ) )

      if employee.save
        render json: { status: :created, employee: employee }
      else
        render json: { status: :unprocessable_entity, errors: employee.errors.full_messages }
      end
    else
      render json: { status: :unprocessable_entity, errors: "You don't have access, must be an admin" }
    end

  end

  private

  def admin_params
    params.permit(:email, :password, :password_confirmation )
  end

  def employee_params
    params.permit( :email, :password, :password_confirmation )
  end



  end
