class Prescribtion < ApplicationRecord
  belongs_to :appointment
  has_one :bill
  accepts_nested_attributes_for :bill
end