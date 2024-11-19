class User < ApplicationRecord
  belongs_to :company, optional: true
  has_many :participations, class_name: 'EventParticipant'
  has_many :events, through: :participations
  validates :identifier, presence: true
  enum :role, {
    member: 'member',
    owner: 'owner'
  }
end
