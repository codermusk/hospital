class Hospital < ApplicationRecord
  has_and_belongs_to_many :doctors , join_table: :hospital_doctors
  accepts_nested_attributes_for :doctors
  has_many :ratings , as: :ratable
  validates :name , presence: true ,length:  {minimum: 5 , maximum: 20}
  validates :address , presence: true,length: {minimum: 20 , maximum:50}
  validates :mail , presence: true , uniqueness: true
end