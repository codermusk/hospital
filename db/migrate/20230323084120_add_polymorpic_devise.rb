class AddPolymorpicDevise < ActiveRecord::Migration[6.0]
  def change
    add_reference :accounts , :accountable , polymorphic: true  , index:true
  end
end
