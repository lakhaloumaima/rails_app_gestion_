class Request < ApplicationRecord
  mount_uploader :certificate, CertificateUploader

  # def certificate_url
  #   if certificate.present?
  #     Rails.application.routes.url_helpers.rails_blob_url(certificate, only_path: true)
  #   end
  # end

  belongs_to :user

  enum status: [ :in_progress , :accepted  , :refused  ]


end
