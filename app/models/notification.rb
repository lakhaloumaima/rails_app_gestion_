# app/models/notification.rb

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :sender, class_name: 'User'
  belongs_to :company

  enum status: { unread: 0, read: 1 }

  validates :message, presence: true
  validates :receiver_type, presence: true
  validates :receiver_id, presence: true
  validates :company_id, presence: true, if: -> { receiver_type == 'admin' || receiver_type == 'HR' }
end
