class CreateTeams < ActiveRecord::Migration

  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.references :subscription, index: true, null: false
      t.timestamps
    end
    add_foreign_key :teams, :subscriptions
  end

end
