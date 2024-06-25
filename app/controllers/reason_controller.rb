class ReasonController < ApplicationController

    #liste des reasons consultée par l ' admin
    def index
        @reasons = Reason.all.order('created_at DESC')
        render json:  {
            reasons:   @reasons.paginate(:page => params[:page] )

        }

    end

    # reason crée par l ' admin
    def create

        @reason = Reason.new(post_params)

        if @reason.save

            render json: @reason

        else
            render json: @reason.errors
        end
    end

    # reason cherchée par l ' admin par ID :
    def show
        @reason = Reason.find(params[:id])
        render json: @reason

    end

    # reason modifiée par l ' admin
    def update

        @reason = Reason.find(params[:id])

        if @reason.update(post_params)

          render json: @reason

        else
          render json: @reason.errors, statut: :unprocessable_entity
        end

    end


    # reason suprimée par l ' admin
    def destroy
        @reason = Reason.find(params[:id])
        @requests = Request.where( reason_id: @reason.id )
        @requests.destroy_all
        @reason.destroy
    end

    def getreasondata
        @reason = Reason.where(id: params[:id])
        render json: @reason
    end

    private

    def post_params
      params.permit(  :name )
    end


end
