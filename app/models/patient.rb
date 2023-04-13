# frozen_string_literal: true

class Patient < ApplicationRecord
  has_many :appointments
  has_one :account , :as =>  :accountable , dependent: :destroy
  validates :name , presence:true
  validates :age , presence:true , numericality: {greater_than: 0 , less_than: 99}
  has_many :doctors , through: :appointments
  accepts_nested_attributes_for :account
  has_many :ratings  , dependent: :destroy
  validates :sex , presence:true
  validates :mobile_number , presence:true

end
