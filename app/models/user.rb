class User < ApplicationRecord
  belongs_to :company, optional: true
  validates :identifier, presence: true
  enum :role, {
    member: 'member',
    owner: 'owner'
  }
end
