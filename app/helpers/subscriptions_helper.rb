module SubscriptionsHelper

  def remaining_in_trial(subscription)
    if trial_ends_at = subscription.trial_ends_at
      distance_of_time_in_words(Time.current, trial_ends_at)
    end
  end

end
