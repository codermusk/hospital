class Prescribtion < ApplicationRecord
  belongs_to :appointment
  has_one :bill
  accepts_nested_attributes_for :bill
  validates :tablets , presence: true
  validates :comments , presence: true , length: {minimum: 10 }
  validates :fees , presence: true  , numericality: {greater_than: 999 , less_than: 9999999}
end