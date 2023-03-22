class CreateHospital < ActiveRecord::Migration[6.0]
  def change
    create_table :hospitals do |t|
      t.string :name
      t.string :address
      t.string :mail
      t.timestamps

    end
  end
end
