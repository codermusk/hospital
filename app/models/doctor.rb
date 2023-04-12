class Doctor < ApplicationRecord
  before_commit do
    email.downcase!
  end
  paginates_per 6
  has_many :appointments
  has_many :ratings , as: :ratable , dependent: :destroy
  has_and_belongs_to_many :hospitals ,join_table: :hospital_doctors
  has_many :patients , through: :appointments
  validates :name , presence: true
  validates :email , presence:true , uniqueness: true
  validates :address , presence:true , length: {minimum: 15}
  validates :age , presence:true , numericality: {greater_than: 20}
  has_one :account  , :as => :accountable , dependent: :destroy
  validates :specialization , presence: true
  accepts_nested_attributes_for :account

end