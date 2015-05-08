class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :rememberable, :async

  mount_uploader :profile_image, ProfileImageUploader

  belongs_to :team
  has_many :subscriptions, dependent: :destroy

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  delegate :plan, to: :subscription, allow_nil: true
  delegate :scheduled_for_cancellation_on, to: :subscription, allow_nil: true

  before_save :ensure_authentication_token_is_present

  def name
    [first_name, last_name].join(" ").strip
  end

  def super_admin?
    role == "super_admin"
  end

  def as_json(options={})
    new_options = options.merge(only: [:email, :first_name, :last_name, :current_sign_in_at])

    super new_options
  end

  private

  def ensure_authentication_token_is_present
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
