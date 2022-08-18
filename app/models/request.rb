class Request < ApplicationRecord

  belongs_to :user

  enum status: [ :in_progress , :accepted  , :refused  ]





end
