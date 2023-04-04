# frozen_string_literal: true

class Patient < ApplicationRecord
  has_many :appointments
  has_one :account , :as =>  :accountable
  validates :name , presence:true
  validates :age , presence:true , numericality: {greater_than: 0 , less_than: 99}
  validates :email , uniqueness: true
  accepts_nested_attributes_for :account
  has_many :ratings  , dependent: :destroy

  validates :sex , presence:true
  validates :mobile_number , presence:true

end
