class Doctor < ApplicationRecord
  before_commit do
    email.downcase!
  end
  has_many :appointments
  has_many :ratings , as: :ratable
  has_and_belongs_to_many :hospitals ,join_table: :hospital_doctors
  has_many :patients , through: :appointments
  validates :name , presence: true
  validates :email , presence:true , uniqueness: true
  validates :address , presence:true
  validates :age , presence:true
  validates :dateofjoining , presence:true
  validates :dateofjoining , presence:true
  has_one :account  , :as => :accountable , dependent: :destroy
  accepts_nested_attributes_for :account

end