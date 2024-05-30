class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.integer :status , null:false , default: "0"
      t.date :start_date
      t.date :end_date
      t.string :description , default: ""
      t.string :motif_refused , default: ""
      t.integer :days
      t.string :certificate

      t.timestamps
    end
  end
end
