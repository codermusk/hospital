
class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient
  has_one :prescribtion , dependent: :destroy
  validates :appointment_date , presence: true
  validates :time , presence: true
  has_one :bill , through: :prescribtion , dependent: :destroy
end
