class AddColumnsToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :user_id , :integer
    add_index  :requests, :user_id

    add_column :requests, :reason_id , :integer
    add_index  :requests, :reason_id
  end
end
