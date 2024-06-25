class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_channel'
  end


  def create(data)
    @message = Message.new(data['message'])
    if @message.save
      ActionCable.server.broadcast('chat_channel', { messages: @message })
    else
      ActionCable.server.broadcast('chat_channel', { errors: @message.errors.full_messages })
    end
  end

  # def receive(data)
  #   ActionCable.server.broadcast "chat_channel", message: data["message"]
  # end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
