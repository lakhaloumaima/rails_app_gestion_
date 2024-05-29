class AddCertificateToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :certificate, :string
  end
end
