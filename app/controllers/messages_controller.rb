class MessagesController < ApplicationController
  # before_action :set_message, only: %i[ show update destroy ]
  # before_action :authenticate_user! # Ensures user is authenticated before accessing messages

  # GET /messages
  def index
    # if params[:candidature_id].present?
    #   @messages = Message.where(candidature_id: params[:candidature_id])
    # end
    # render json: @messages
    @messages = Message.all.includes( :sender, :receiver).order(created_at: :desc)
    @messages.each do |message|
      sender_first_name = message.sender.email
      receiver_first_name = message.receiver.email

      # Use sender_first_name and receiver_first_name as needed
    end
    render json: @messages, include: [:sender, :receiver]

  end

    # GET /messages
    def getMessagesByReceiverId
      # if params[:candidature_id].present?
      #   @messages = Message.where(candidature_id: params[:candidature_id])
      # end
      # render json: @messages
      @messages = Message.where( receiver_id: params[:receiver_id], sender_id: params[:sender_id]).includes( :sender, :receiver).order(created_at: :desc)
      @messages.each do |message|
        sender_first_name = message.sender.email
        receiver_first_name = message.receiver.email

        # Use sender_first_name and receiver_first_name as needed
      end

      render json: @messages, include: [:sender, :receiver]

    end

    def getMessagesBySenderId
      # if params[:candidature_id].present?
      #   @messages = Message.where(candidature_id: params[:candidature_id])
      # end
      # render json: @messages
      @messages = Message.where(sender_id: params[:sender_id], receiver_id: params[:receiver_id] ).includes( :sender, :receiver).order(created_at: :desc)
      @messages.each do |message|
        sender_first_name = message.sender.email
        receiver_first_name = message.receiver.email

        # Use sender_first_name and receiver_first_name as needed
      end
      render json: @messages, include: [:sender, :receiver]

    end

  # POST /messages
  def create
    @message = Message.new(message_params)

    # @message.sender_id = 4
    # @message.receiver_id = 20 # params[:receiver_id]

    if @message.save
      # byebug

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
