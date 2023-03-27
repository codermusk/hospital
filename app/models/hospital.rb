class Hospital < ApplicationRecord
  has_many :doctors
  has_many :ratings , as: :ratable
  validates :name , presence: true
  validates :address , presence: true
  validates :mail , presence: true
end