class MessagesController < ApplicationController
  # before_action :set_message, only: %i[ show update destroy ]

  # GET /messages
  def index
    # if params[:candidature_id].present?
    #   @messages = Message.where(candidature_id: params[:candidature_id])
    # end
    # render json: @messages
    render json: Message.all

  end

  # POST /messages
  def create
    @message = Message.new(message_params)
    @message.sender_id = 20 # current_user.id
    @message.receiver_id = 4 # params[:receiver_id]

    if @message.save
      ActionCable.server.broadcast('chat_channel', { message: @message })
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      # params.require(:message).permit(:body, :sender_id, :receiver_id )
      params.permit(:message, :sender_id, :receiver_id )
    end

end
