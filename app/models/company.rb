class Company < ApplicationRecord

  has_many :users
  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true

end
