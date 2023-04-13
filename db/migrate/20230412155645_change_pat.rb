class ChangePat < ActiveRecord::Migration[6.0]
  def up
    remove_column :patients , :email
  end

  def down
    add_column :patients , :email , :string
  end
end
