class CreateSubscriptions < ActiveRecord::Migration

  def change
    create_table :subscriptions do |t|
      t.references :user, index: true
      t.date :deactivated_on
      t.date :scheduled_for_cancellation_on
      t.integer :plan_id
      t.string :plan_type, default: "IndividualPlan", null: false
      t.decimal :next_payment_amount, default: 0.0, null: false
      t.date :next_payment_on
      t.string :stripe_id
      t.timestamps
    end
    add_index :subscriptions, :stripe_id
    add_index :subscriptions, :plan_id
    add_foreign_key :subscriptions, :users
  end

end
