class AddColToAppointmnent < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments , :time ,:string
  end
end
