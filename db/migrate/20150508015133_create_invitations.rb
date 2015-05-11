class CreateInvitations < ActiveRecord::Migration

  def change
    create_table :invitations do |t|
      t.string :email, null: false
      t.string :code, null: false
      t.datetime :accepted_at
      t.integer :sender_id, null: false
      t.integer :recipient_id
      t.references :team, index: true, null: false
      t.timestamps
    end
    add_index :invitations, :code
    add_foreign_key :invitations, :teams
  end

end
