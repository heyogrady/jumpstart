module SubscriptionsHelper

  def days_remaining_in_trial(subscription)
    if trial_ends_at = subscription.trial_ends_at
      days_left = seconds_to_days(trial_ends_at - Time.current)
      "#{pluralize(days_left, 'day')}"
    end
  end

  private

  def seconds_to_days(seconds)
    (seconds / 86400).round.to_i if seconds
  end

end
