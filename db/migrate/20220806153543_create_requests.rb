class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|

      t.integer :status , null:false , default: "0" 
      t.date :start_date 
      t.date :end_date 
      t.string :reason
      t.string :motif_refused

      t.timestamps
    end
  end
end
