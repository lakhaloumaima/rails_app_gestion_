class RequestController < ApplicationController

   # before_action :verify_authenticity_token

    #liste des demandes consultée par l ' admin
    def index
        @requests = Request.all.order('created_at DESC')
        render json:  { 
            requests:   @requests.paginate(:page => params[:page] ) 
        } , include: [ :user  ]

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
        @requests = Request.where(user_id: params[:user_id]).order('created_at DESC')
        render json:  { 
            requests:   @requests.paginate(:page => params[:page] ) 
        } , include: [ :user  ]
    end

    # request updated by employee
    def updateRequestByEmployee
        @request = Request.find(params[:id])
        if @request.update(post_params4)
        render json: @request , include: [ :user ] 

        else
        render json: @request.errors, statut: :unprocessable_entity
        end
    end

    def getrequestinprogressbyemployee
        
        @requests = Request.where("status = ?" , status = 0 )
    
        render json:  { 
            requests:   @requests.paginate(:page => params[:page] ) 
        } , include: [ :user  ]
    end

    def getrequestacceptedbyemployee
        
        @requests = Request.where("status = ?" , status = 1 )
    
        render json:  { 
            requests:   @requests.paginate(:page => params[:page] ) 
        } , include: [ :user  ]
    end

    def getrequestrefusedbyemployee
        
        @requests = Request.where("status = ?" , status = 2 )
    
        render json:  { 
            requests:   @requests.paginate(:page => params[:page] ) 
        } , include: [ :user  ]
    end


    def getrequestdata
        @request = Request.where(id: params[:id])
        render json: @request , include: [ :user ]
    end




    private

    def post_params
        params.permit(:status, :start_date, :end_date, :reason , :motif_refused, :user_id )
        
    end

    def post_params2
        params.permit( :status, :start_date, :end_date,:reason , :motif_refused, :user_id  )
    end

    def post_params3
        params.permit( :status, :motif_refused, :user_id  )
    end

    def post_params4
        params.permit( :start_date, :end_date , :reason )
    end


end
