
class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient
  has_one :prescribtion
  validates :appointment_date , presence: true
  validates :time , presence: true

end
