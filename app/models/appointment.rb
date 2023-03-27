# frozen_string_literal: true

class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient
  has_one :prescribtion
  validates :appointment_date
  validates :time

end
