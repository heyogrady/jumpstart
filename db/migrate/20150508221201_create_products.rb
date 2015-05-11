class CreateProducts < ActiveRecord::Migration

  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.string :tagline
      t.string :call_to_action
      t.string :short_description
      t.text :description
      t.string :type, null: false
      t.boolean :active
      t.text :questions
      t.text :terms
      t.text :alternative_description
      t.string :product_image_file_name
      t.string :product_image_file_size
      t.string :product_image_content_type
      t.string :product_image_updated_at
      t.boolean :promoted, default: false, null: false
      t.string :slug, null: false
      t.text :resources, default: "", null: false
      t.timestamps
    end
    add_index :products, :slug
  end

end
