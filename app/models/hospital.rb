class Hospital < ApplicationRecord
  has_and_belongs_to_many :doctors , join_table: :hospital_doctors
  accepts_nested_attributes_for :doctors
  has_many :ratings , as: :ratable
  validates :name , presence: true
  validates :address , presence: true
  validates :mail , presence: true
end