class Rating < ApplicationRecord
  validates :review , presence:true
  validates :rating , presence:true  ,numericality: {greater_than: 0 ,less_than: 11}
  belongs_to :ratable , polymorphic: true
  belongs_to :patient
end