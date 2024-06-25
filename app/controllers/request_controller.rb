class RequestController < ApplicationController

    #liste des demandes consultée par l ' admin
    def index
        # Fetch the company using the company_id parameter
        company = Company.find(params[:company_id])

        # Fetch users that belong to the company
        users = company.users

        @requests = Request.where(user_id: users.pluck(:id)).order('created_at DESC')

        render json:  {
            requests:   @requests.paginate(:page => params[:page] )

        } , include: [ :user, :reason ]

        #   @request = Request.paginate(:page => params[:page], :per_page => 10)
    end

    # request crée par l ' employee
    def create
        @request = Request.new(post_params)

        if @request.save
          sender = @request.user
          company = sender.company

          admin_users = company.users.where(role: 'admin')
          hr_users = company.users.where(role: 'HR')

          admin_users.each do |admin|
            Notification.create(
              user: admin,
              sender: sender,
              message: "New request created by #{sender.email} for #{@request.reason} ",
              status: 'unread',
              receiver_type: 'admin',
              receiver_id: admin.id,
              company_id: company.id
            )
          end

          hr_users.each do |hr|
            Notification.create(
              user: hr,
              sender: sender,
              message: "New request created by #{sender.email} for #{@request.reason} ",
              status: 'unread',
              receiver_type: 'HR',
              receiver_id: hr.id,
              company_id: company.id
            )
          end


            # Broadcast the new request to the notification channel
            ActionCable.server.broadcast("notification_channel", {
                type: 'new_request',
                message: "New request created by #{sender.email} for #{@request.reason}",
                request: @request
            })

          render json: @request, include: [:user, :reason], status: :created
        else
          render json: @request.errors, status: :unprocessable_entity
        end
      end

    # request cherchée par l ' admin par ID :
    def show
        @request = Request.find(params[:id])
        render json: @request

    end

    # demande modifiée par l ' admin
    def update
        @request = Request.find(params[:id])

        if post_params3[:status] == "in_progress" || post_params3[:status] == "refused"
            if @request.update(post_params3)
                render json: @request, include: [:user, :reason]
            else
                render json: @request.errors, status: :unprocessable_entity
            end
        elsif post_params3[:status] == "accepted"
            @user = User.find(@request.user_id)
            solde = (@user.solde).to_i
            request_days = @request.days.to_i
            result = (solde - request_days).to_i

            if @request.update(post_params3) && @user.update(solde: result)
                render json: @request, include: [:user, :reason]
            else
                render json: { errors: @request.errors.full_messages + @user.errors.full_messages }, status: :unprocessable_entity
            end
        else
            render json: @request.errors, status: :unprocessable_entity
        end
    end



    # request suprimée par l ' admin
    def destroyR
        @request = Request.find(params[:id])
        @request.destroy
    end

    def getAllRequestsByCompany
        # Fetch the company using the company_id parameter
        company = Company.find(params[:company_id])

        # Fetch users that belong to the company
        users = company.users

        # Fetch requests for the users of the company
        requests = Request.where(user_id: users.pluck(:id))


        render json:  {
            requests:   requests.paginate(:page => params[:page] )
        } , include: [ :user, :reason ]
    end

    def getAllEmployeesByCompanyWithoutAdmin
      # Fetch the company using the company_id parameter
      company = Company.find(params[:company_id])

      # Fetch users that belong to the company and exclude those with role "0"
      users = company.users.where(email_confirmed: true).where.not( role: 0 ).paginate(page: params[:page])

      # Generate avatar URLs
      users_with_avatars = users.map do |user|
        if user.avatar.attached?
          user.as_json.merge(
            avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil
          )
        else
          user
        end
      end
      render json: {
        employees: users_with_avatars
      }, include: [:company]
  end

    def getAllEmployeesByCompany
        # Fetch the company using the company_id parameter
        company = Company.find(params[:company_id])

        # Fetch users that belong to the company and exclude those with role "0"
        users = company.users.where(email_confirmed: true).paginate(page: params[:page])

        # Generate avatar URLs
        users_with_avatars = users.map do |user|
          if user.avatar.attached?
            user.as_json.merge(
              avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil
            )
          else
            user
          end
        end
        render json: {
          employees: users_with_avatars
        }, include: [:company]
    end

      def getAllUsersByCompanyConfirmed
        # Fetch the company using the company_id parameter
        company = Company.find(params[:company_id])

        # Fetch users that belong to the company and exclude those with role "0"
        users = company.users.where(email_confirmed: true).where.not(role: "0").paginate(page: params[:page])

        render json: {
          employees: users
        }, include: [:company]
      end

      def getAllUsersByCompany
        # Fetch the company using the company_id parameter
        company = Company.find(params[:company_id])

        # Fetch users that belong to the company and exclude those with role "0"
        users = company.users.where.not(role: "0").paginate(page: params[:page])

        render json: {
          employees: users
        }, include: [:company]
      end


    def getRequestsByID
        @requests = Request.where(user_id: params[:user_id]).order('created_at DESC')
        render json:  {
            requests:   @requests.paginate(:page => params[:page] )
        } , include: [ :user, :reason ]
    end

    def getRequestsByIDAccepted
        @requests = Request.where(user_id: params[:user_id]).where("status = ?" , status = 1 ).order('created_at DESC')
        render json:  {
            requests:   @requests.paginate(:page => params[:page] )
        } , include: [ :user, :reason ]
    end

    # request updated by employee
    def updateRequestByEmployee
        @request = Request.find(params[:id])
        days = (@request.end_date.to_date - @request.start_date.to_date).to_i + 1

        if @request.update(post_params4) && @request.update(days: days)
            byebug

            render json: @request, include: [:user, :reason]
        else
            render json: @request.errors, status: :unprocessable_entity
        end
    end


    def getrequestinprogressbyemployee

        # Fetch the company using the company_id parameter
        company = Company.find(params[:company_id])

        # Fetch users that belong to the company
        users = company.users

        # Fetch requests for the users of the company
        @requests = Request.where(user_id: users.pluck(:id)).where("status = ?" , status = 0 )

        render json:  {
            requests:   @requests.paginate(:page => params[:page] )
        } , include: [ :user, :reason ]
    end

    def getrequestacceptedbyemployee
        # Fetch the company using the company_id parameter
        company = Company.find(params[:company_id])

        # Fetch users that belong to the company
        users = company.users

        # Fetch requests for the users of the company
        @requests = Request.where(user_id: users.pluck(:id)).where("status = ?" , status = 1 )

        render json:  {
            requests:   @requests.paginate(:page => params[:page] )
        } , include: [ :user, :reason ]
    end

    def getrequestrefusedbyemployee
        # Fetch the company using the company_id parameter
        company = Company.find(params[:company_id])

        # Fetch users that belong to the company
        users = company.users

        # Fetch requests for the users of the company
        @requests = Request.where(user_id: users.pluck(:id)).where("status = ?" , status = 2 )

        render json:  {
            requests:   @requests.paginate(:page => params[:page] )
        } , include: [ :user, :reason ]
    end

    def getrequestdata
        @request = Request.where(id: params[:id])
        render json: @request , include: [ :user, :reason ]
    end


    def getRequestByEmail
        requests = Request.joins(:users).where(email: params[:email])
        render json:  {
            requests:   @requests
        } , include: [ :user, :reason ]
    end

    def import_pdf
        @request = Request.find(params[:id])
        Rails.logger.info("Received params: #{params.inspect}")
        if @request.update(certificate: params[:certificate])
          render json: @request
        else
          render json: @request.errors, status: :unprocessable_entity
        end
    end

    def export_certificate
        request = Request.find(params[:id])
        if request.certificate.present?
            send_file request.certificate.path,
                    filename: "certificate_#{request.user.email}.pdf",
                    type: "application/pdf",
                    disposition: 'attachment'
        else
            render json: { error: "Certificate not found" }, status: :not_found
        end
    end

    # def export_pdf
    #     @request = Request.find(params[:id])
    #     pdf = generate_pdf(@request)
    #     send_data pdf.render, filename: "certificate_#{@request.id}.pdf", type: 'application/pdf'
    # end


    private

    # def generate_pdf(request)
    #     Prawn::Document.new do
    #         text "Certificate for Request ID: #{request.id}", size: 30, style: :bold
    #         text "Reason: #{request.reason}"
    #         text "Description: #{request.description}"
    #         text "Start Date: #{request.start_date}"
    #         text "End Date: #{request.end_date}"
    #         text "End Date: #{request.certificate}"
    #     end
    # end

    def post_params
        params.permit(:start_date, :end_date, :reason_id, :description, :user_id, :certificate)
    end

    def post_params3
        params.permit( :status , :motif_refused , :user_id )
    end

    def post_params4
        params.permit( :start_date, :end_date , :description , :certificate )
    end


end
