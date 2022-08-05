class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  before_create :confirmation_token
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable 
    

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_uniqueness_of :email

  enum role: [ :admin , :employee  ]

  has_many :requests , dependent: :destroy 
  
  has_one_attached :avatar, dependent: :destroy
  
  def user_image_url
    avatar.attached? ? url_for(avatar) : nil
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
  end

  def confirmation_token
    self.confirm_token = SecureRandom.urlsafe_base64.to_s if confirm_token.blank?
  end

  # This generates a random password reset token for the user
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end


end
