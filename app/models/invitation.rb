class Invitation < ActiveRecord::Base

  belongs_to :recipient, class_name: User
  belongs_to :sender, class_name: User
  belongs_to :team

  validates :email, presence: true
  validates :sender_id, presence: true
  validates :team_id, presence: true

  delegate :name, to: :recipient, prefix: true, allow_nil: true

end
