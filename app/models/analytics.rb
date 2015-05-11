class Analytics

  include AnalyticsHelper

  attr_accessor :user
  class_attribute :backend
  self.backend = AnalyticsRuby

  def initialize(user=nil, client_id=nil)
    @user = user
    @client_id = client_id
  end

  def track(options)
    if client_id.present?
      options.merge!(context: { "Google Analytics" => { clientId: client_id } })
    end
    backend.track({ user_id: identified_user_id }.merge(options))
  end

  def track_user_creation
    identify
    track(event: "Created User")
  end

  def track_user_sign_in
    identify
    track(event: "Signed In User")
  end

  def track_updated
    backend.identify(user_id: user.id, traits: identify_hash(user))
  end

  def track_cancelled(reason)
    identify
    track(event: "Cancelled", properties: { reason: reason, email: user.email })
  end

  private

  def identify
    backend.identify(identify_params)
  end

  attr_reader :user, :client_id

  def identify_params
    if user
      { user_id: identified_user_id,
        traits: user_traits
      }
    else
      { user_id: 0,
        traits: { first_name: "N/A", last_name: "N/A" }
      }
    end
  end

  def user_traits
    { first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      organization: user.organization,
      address1: user.address1,
      address2: user.address2,
      city: user.city,
      state: user.state,
      zip_code: user.zip_code,
      country: user.country,
      created_at: user.created_at
    }.reject { |_key, value| value.blank? }
  end

  def identified_user_id
    if user
      user.id
    else
      0
    end
  end

end
