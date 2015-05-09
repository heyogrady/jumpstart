class Catalog

  include ActiveModel::Conversion

  def products
    Product.active.ordered
  end

  def individual_plans
    Plan.individual.featured.active.ordered
  end

  def team_plan
    Plan.default_team
  end

end
