class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  # private

  #   def broadcast_message
  #     ActionCable.server.broadcast('chat_channel', {
  #       id: self.id,
  #       message: self.message,
  #       sender_id: self.sender_id,
  #       receiver_id: self.receiver_id
  #     })
  #   end

end
