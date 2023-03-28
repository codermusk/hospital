# frozen_string_literal: true

class Patient < ApplicationRecord
  has_many :appointments
  has_one :account , :as =>  :accountable
  validates :name , presence:true
  validates :age , presence:true

  validates :sex , presence:true
  validates :mobile_number , presence:true

  # belongs_to :doctor
end
