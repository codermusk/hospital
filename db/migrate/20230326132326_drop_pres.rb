class DropPres < ActiveRecord::Migration[6.0]
  def change
    drop_table :prescription
  end
end
