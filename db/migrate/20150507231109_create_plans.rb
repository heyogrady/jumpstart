class CreatePlans < ActiveRecord::Migration

  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :sku, null: false
      t.string :short_description, null: false
      t.text :description, null: false
      t.boolean :active, default: true, null: false
      t.integer :price_in_dollars, null: false
      t.text :terms
      t.boolean :featured, default: false, null: false
      t.boolean :annual, default: false
      t.integer :annual_plan_id
      t.integer :minimum_quantity, default: 1, null: false
      t.timestamps
    end
    add_index :plans, :annual_plan_id
  end

end
