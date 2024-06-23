class AddSoldeToCompany < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :solde, :integer

  end
end
