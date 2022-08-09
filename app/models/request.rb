class Request < ApplicationRecord

    belongs_to :user

    enum status: [ :in_progress , :accepted  , :refused  ]

   # attribute :status, :integer, default: '0'

    validate :start_date_equal_or_after_end_date?

    def start_date_equal_or_after_end_date?
      if end_date < start_date 
        errors.add :dateDebut, "end_date must be equal or after start_date ! "
      end
    end

end
