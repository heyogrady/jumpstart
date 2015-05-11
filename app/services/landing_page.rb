class LandingPage

  def community_size
    User.subscriber_count
  end

  def primary_plan
    Plan.popular
  end

  def secondary_plan
    Plan.basic
  end

end
