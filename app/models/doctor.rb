class Doctor < ApplicationRecord
  has_many :appointments
  has_many :ratings , as: :ratable
  belongs_to :hospital
  has_many :patients , through: :appointments
  validates :name , presence: true
  validates :email , presence:true
  validates :address , presence:true
  validates :age , presence:true
  validates :dateofjoining , presence:true
  validates :dateofjoining , presence:true
  has_one :account  , :as => :accountable

end