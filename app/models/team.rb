class Team < ActiveRecord::Base

  belongs_to :subscription

  has_many :users, dependent: :nullify
  has_many :invitations

  validates :name, presence: true

end
