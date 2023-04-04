class Bill < ApplicationRecord
  belongs_to :prescribtion
  validates :doctor_fees ,presence:true , numericality: {greater_than: 999 , less_than: 100000}
end