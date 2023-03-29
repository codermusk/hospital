class CreateHospitalDoctors < ActiveRecord::Migration[6.0]
  def change
    create_table :hospital_doctors do |t|
      t.belongs_to :doctor
      t.belongs_to :hospital

    end
  end
end

