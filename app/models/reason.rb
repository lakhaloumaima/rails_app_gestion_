class Reason < ApplicationRecord

  # def certificate_url
  #   if certificate.present?
  #     Rails.application.routes.url_helpers.rails_blob_url(certificate, only_path: true)
  #   end
  # end

  has_many :requests, dependent: :destroy



end
