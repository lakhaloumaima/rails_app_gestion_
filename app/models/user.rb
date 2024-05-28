class User < ApplicationRecord
  include Rails.application.routes.url_helpers


  before_create :confirmation_token
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_uniqueness_of :email

  enum role: [ :admin , :employee  ]

  has_many :requests , dependent: :destroy

  has_one_attached :avatar, dependent: :destroy


  ###########################################     ACTIVATE EMAIL      ################################################
  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
  end

  def confirmation_token
    self.confirm_token = SecureRandom.urlsafe_base64.to_s if confirm_token.blank?
  end

  ###########################################     PASWWORD RESET      ################################################


  #  self.reset_password_token = generate_token
  def send_reset_password
    generate_token(:reset_password_token)
    self.reset_password_sent_at = Time.zone.now
    save!
    UserMailer.forgot_password(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end


  ########################


end
