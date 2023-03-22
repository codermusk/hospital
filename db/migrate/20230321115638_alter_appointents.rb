class AlterAppointents < ActiveRecord::Migration[6.0]
  def up
    remove_column :appointments , :status
  end

  def down
    add_column :appointments , :status , :boolean
  end
end
