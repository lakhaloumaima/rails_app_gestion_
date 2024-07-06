
class EmployeeController < ApplicationController
  #  before_action :authenticate_user!

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_confirmed = true
      user.confirm_token = nil
      if user.save(validate: false) # Exclude password validation
        redirect_to 'http://localhost:4200/'
      else
        Rails.logger.error(user.errors.full_messages) # Log validation errors
        render json: { error: 'Failed to save user' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end


  # def confirm_email
  #   user = User.find_by_confirm_token(params[:id])
  #   if user
  #     user.email_confirmed = true
  #     user.confirm_token = nil

  #     redirect_to 'http://localhost:4200/' if  user.save

  #     # redirect_to 'https://gestionfront.herokuapp.com/' , allow_other_host: true
  #   else

  #     render json: { status: 500 }

  #   end

  # end

  # employee crée par l ' admin
  def createEmployee

    @employee = User.new(post_params1)
    # cover_url = rails_blob_path(@employee.avatar, disposition: "attachment")
    @employee.solde = @employee.company.solde if @employee.company.present?

    if @employee.save

      UserMailer.registration_confirmation(@employee).deliver

      @employee  = @employee.avatar.attach(io: File.open(Rails.root.join('public', 'logo2.jpeg')), filename: 'logo2.jpeg')

      # @employee = User.last.avatar.attach(io: File.open("#{Rails.root}/app/assets/images/logo2.jpeg"),filename: 'logo2.jpeg', content_type: 'image/png')

      render json: {

        employee: @employee,

      #  avatar: cover_url
      #  methods: [:user_image_url]
      }, status: :ok
    #  render json:  @employee

    else
        render json: @employee.errors
    end
  end


  def updateuser
    @user = User.find(params[:id])

    # cover_url = rails_blob_path(@user.avatar, disposition: "attachment")
    # @user.avatar.attach(io: File.open(Rails.root.join('public', 'logo2.jpeg')), filename: 'logo2.jpeg')

    av =  @user.avatar.attached? ? url_for( @user.avatar) : nil
    @user.company.update(company_params) if params[:name].present? || params[:subdomain].present? || params[:solde].present?

    if @user.update(post_paramsEmployee )

      render json:  {

        role: @user.role  ,
        id: @user.id  ,
        user: @user ,
        avv: av
      }, include: [:company]

    else
      render json: @user.errors, statut: :unprocessable_entity
    end
  end

  # def updateuser
  #   if @user.update(user_params)
  #     update_company if @user.company.present?

  #     render json: { user: @user, avatar_url: avatar_url(@user) }, status: :ok
  #   else
  #     render json: @user.errors, status: :unprocessable_entity
  #   end
  # end

  #liste des employees consultée par l ' admin
  def getAllEmployees
    @employees = User.where.not( role: 0 ).order('id DESC')

    render json:  {
      employees:  @employees.paginate(:page => params[:page] )

    }

    #   @demandes = Demande.paginate(:page => params[:page], :per_page => 10)
  end

    #liste des employees consultée par l ' admin
    def getAllUsers
      @users = User.order('id DESC')

      render json:  {
        employees:  @users.paginate(:page => params[:page] )

      }

      #   @demandes = Demande.paginate(:page => params[:page], :per_page => 10)
    end

  def getemployedata
    @user = User.where(id: params[:id])
    render json: @user
  end

  def getEmployeeByEmail
    employee = User.where(email: params[:email])
    render json: employee
  end

  def getUsersByRole
    # Fetch the company using the company_id parameter
    company = Company.find(params[:company_id])

    # Fetch users that belong to the company with the specified role
    users = company.users.where(role: params[:role]).paginate(page: params[:page])

    # Generate avatar URLs
    # users_with_avatars = users.map do |user|
    #   if user.avatar.attached?
    #     user.as_json.merge(
    #       avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil
    #       )
    #   else
    #     user
    #   end
    # end

    render json: {
      employees: users
    }, include: [:company]
  end


  def getUserById
    user = User.find(params[:id])

      user.as_json.merge(
        avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil
      )

    render json: { user: user }, include: [ :company ]
  end


  def updateimageuser
    @user = User.find(params[:id])

    if @user.update(paramsimageuser)
      # cover_url = rails_blob_path(@user.avatar, disposition: "attachment")
      # av =  @user.avatar.attached? ? url_for(@user.avatar) : nil
      # byebug
      # @user  =  @user.avatar.attach(io: File.open(Rails.root.join('public', 'logo2.jpeg')), filename: 'logo2.jpeg')
      av =  @user.avatar.attached? ? url_for( @user.avatar) : nil

      render json:  {

        role: @user.role  ,
        id: @user.id  ,
        user: @user ,
        avv: av
      }


    else
      render json: @user.errors, statut: :unprocessable_entity
    end
  end


  def countAll
    company = Company.find(params[:company_id])

    employees = company.users.where.not(role: 'admin')

    requests = Request.where(user_id: employees.pluck(:id))

    @request_inprogress = requests.select { |m| m.status =='in_progress' }.count
    @request_accepted = requests.select { |m| m.status == 'accepted' }.count
    @request_refused = requests.select { |m| m.status == 'refused' }.count

    @employee_count = employees.count

    render json: {
    data:[ @employee_count , @request_inprogress  , @request_accepted , @request_refused ]
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
    params.permit( :email, :last_name, :first_name, :address, :phone, :cin , :password )
  end

  # def update_company
  #   @user.company.update(company_params)
  # end

  def company_params
    params.permit(:name, :subdomain,  :solde )
  end

  def post_params1
    params.permit( :email, :password, :last_name, :first_name, :role, :cin, :address, :phone, :company_id )
  end

end
