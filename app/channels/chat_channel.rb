class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_channel'
  end


  def create(data)
    if message.persisted?
      ActionCable.server.broadcast('chat_channel', message: message)
    else
      ActionCable.server.broadcast('chat_channel', errors: message.errors.full_messages)
    end
  end

  # def receive(data)
  #   ActionCable.server.broadcast "chat_channel", message: data["message"]
  # end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
