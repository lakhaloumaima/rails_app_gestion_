class RequestController < ApplicationController

    #liste des demandes consultée par l ' admin
    def index
        @requests = Request.all.order('created_at DESC')
        render json:  {
            requests:   @requests.paginate(:page => params[:page] )

        } , include: [ :user, :reason ]

        #   @request = Request.paginate(:page => params[:page], :per_page => 10)
    end

    # request crée par l ' employee
    def create

        @request = Request.new(post_params)

        days= ( (@request.end_date.to_date - @request.start_date.to_date).to_i) + 1
        @request.update( :days => days )


        if @request.save

            render json: @request , include: [ :user, :reason ]

        else
            render json: @request.errors
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

            @request.update(post_params3)

            render json: @request , include: [ :user, :reason ]

        elsif post_params3[:status] == "accepted"

           @user = User.where("id = ?" ,  @request.user_id )
           solde = @user.pluck( :solde ).join(',').to_i

           request_days = (@request.days)

           result = ( solde - request_days ).to_i

           @request.update(post_params3)
           @user.update(:solde => result)

           render json: @request, include: [  :user, :reason  ]

        else
           render json: @request.errors, statut: :unprocessable_entity
        end

    end


    # request suprimée par l ' admin
    def destroyR
        @request = Request.find(params[:id])
        @request.destroy
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

        days= ( (@request.end_date.to_date - @request.start_date.to_date).to_i) + 1

        if @request.update(post_params4)

            @request.update( :days => days )

            render json: @request , include: [ :user, :reason ]

        else
            render json: @request.errors, statut: :unprocessable_entity
        end
    end

    def getrequestinprogressbyemployee

        @requests = Request.where("status = ?" , status = 0 )

        render json:  {
            requests:   @requests.paginate(:page => params[:page] )
        } , include: [ :user, :reason ]
    end

    def getrequestacceptedbyemployee

        @requests = Request.where("status = ?" , status = 1 )

        render json:  {
            requests:   @requests.paginate(:page => params[:page] )
        } , include: [ :user, :reason ]
    end

    def getrequestrefusedbyemployee

        @requests = Request.where("status = ?" , status = 2 )

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
        params.permit(  :start_date, :end_date, :reason_id , :description , :user_id , :certificate )

    end

    def post_params3
        params.permit( :status , :motif_refused , :user_id )
    end

    def post_params4
        params.permit( :start_date, :end_date , :reason_id , :description , :certificate )
    end


end
