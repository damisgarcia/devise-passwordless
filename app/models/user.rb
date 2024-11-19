class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :database_authenticatable, :confirmable, :lockable, :timeoutable, :rememberable, :recoverable
  # :validatable, :trackable and :omniauthable

  devise :database_authenticatable, :confirmable, :registerable, :trackable

  include LoginToken

  scope :confirmed, -> { where.not(confirmed_at: nil) }
end
