class AddCardDetailsToSubscription < ActiveRecord::Migration

  def change
    add_column :subscriptions, :card_type, :string
    add_column :subscriptions, :card_last_four_digits, :string
    add_column :subscriptions, :card_expires_on, :date
    add_column :subscriptions, :trial_ends_at, :datetime
  end

end
