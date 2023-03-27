class Bill < ApplicationRecord
  belongs_to :prescribtion
  validates :doctor_fees ,presence:true
end