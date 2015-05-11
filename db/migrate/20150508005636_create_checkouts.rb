class CreateCheckouts < ActiveRecord::Migration

  def change
    create_table :checkouts do |t|
      t.references :user, index: true, null: false
      t.references :plan, index: true, null: false
      t.string :stripe_coupon_id
      t.timestamps
    end
    add_foreign_key :checkouts, :users
    add_foreign_key :checkouts, :plans
  end

end
