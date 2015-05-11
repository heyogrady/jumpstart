class AddIncludesTeamsToPlans < ActiveRecord::Migration

  def change
    add_column :plans, :includes_team, :boolean, default: false, null: false
  end

end
