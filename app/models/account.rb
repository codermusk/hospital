class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_commit do
    email.downcase!
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :accountable , :polymorphic => true
end
