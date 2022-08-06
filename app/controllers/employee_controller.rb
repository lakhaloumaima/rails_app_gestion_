
class EmployeeController < ApplicationController
  #  before_action :authenticate_user!


  # after_action :confirm_email

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_confirmed = true
      user.confirm_token = nil
      user.save
      redirect_to 'http://localhost:4200/'


    else
      
      render json: { status: 500 }

    end

  end

  # employee crée par l ' admin
  def createEmployee     

   
    @employee = User.new(post_params1)
    cover_url = rails_blob_path(@employee.avatar, disposition: "attachment")
  
    if @employee.save 

     
      UserMailer.registration_confirmation(@employee).deliver

      render json: {
     
        employee : @employee  ,
      
        avatar: cover_url 
      #  methods: [:user_image_url] 
      }, status: :ok 
    #  render json:  @employee 
      
    else
        render json: @employee.errors
    end      
  end   


  def updateuser
    @user = User.find(params[:id])

    if @user.update(post_paramsEmployee )

      render json: @user 

    else
      render json: @user.errors, statut: :unprocessable_entity
    end
  end

      #liste des employees consultée par l ' admin
  def getAllEmployees
    @employees = User.where(role: '1' ).paginate(:page => params[:page], :per_page => 10).order('id DESC')
    render json: @employees 
    
    #   @demandes = Demande.paginate(:page => params[:page], :per_page => 10)
  end

  def getEmployeesByName
    employees = User.where(last_name: params[:last_name])
    render json: employees
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


  def countAll
    @employees = User.all.select { |m| m.role == 'employee' }.count
    @request_inprogress = Request.all.select { |m| m.status =='in_progress' }.count
    @request_accepted = Request.all.select { |m| m.status == 'accepted' }.count
    @request_refused = Request.all.select { |m| m.status == 'refused' }.count

    render json: {
    data:[ @employees , @request_inprogress  , @request_accepted , @request_refused ]
    }
    
  end

  # demande suprimée par l ' admin
  def destroyE
      @employee = User.find(params[:id])
      @employee.destroy
  end

  private 

  def user_image_url
    avatar.attached? ? url_for(avatar) : nil
  end

  def paramsimageuser
    params.permit(:id, :avatar)
  end

  def post_paramsEmployee
    params.permit( :email, :last_name, :first_name, :address, :phone)
  end

  def post_params1
    params.permit( :email, :password, :role  )
  end

end 