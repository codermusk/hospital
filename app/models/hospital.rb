class Hospital < ApplicationRecord
  has_many :doctors
  validates :name , presence: true
  validates :address , presence: true
  validates :mail , presence: true
end