class RequestController < ApplicationController

   # before_action :verify_authenticity_token

    #liste des demandes consultée par l ' admin
    def index
        @requests = Request.all.paginate(:page => params[:page], :per_page => 10).order('id DESC')
        render json: @requests  , include: [ :user  ]

        #   @request = Request.paginate(:page => params[:page], :per_page => 10)
    end

    # request crée par l ' employee
    def create 
        
        @request = Request.new(post_params)
        #byebug
        if @request.save 
            
            render json: @request , include: [ :user ]
       
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
        if @request.update(post_params3)
        render json: @request , include: [ :user ] 

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
        requests = Request.where(user_id: params[:user_id])
        render json: requests , include: [ :user ] 
    end



        


    private

    def post_params
        params.permit(:status, :start_date, :end_date, :motif_accepted , :motif_refused, :user_id )
        
    end

    def post_params2
        # lazm tbaath kol shy fl update 
        params.permit( :status, :start_date, :end_date,:motif_accepted , :motif_refused, :user_id  )
    end

    def post_params3
        # lazm tbaath kol shy fl update 
        params.permit( :status, :motif_refused, :user_id  )
    end


end
