class Company < ApplicationRecord
  has_many :users
  validates :identifier, presence: true
end
