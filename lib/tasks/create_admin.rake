desc "Sets up initial plans and admin account"
task setup_plans_and_admin_account: :environment do
  create_individual_plans
  create_admin
  checkout_admin(@admin)

  puts "Added plans and admin user successfully"
end

def create_individual_plans
  @lite_plan = create_plan(
    sku: "lite",
    name: "Lite Plan",
    price_in_dollars: 9,
    short_description: "The plan to get you started on a budget.",
    description: "A long description.",
    featured: true
  )

  @standard_plan = create_plan(
    sku: "standard",
    name: "Standard Plan",
    price_in_dollars: 29,
    short_description: "The that gives you the best bang for your buck.",
    description: "A long description.",
    featured: true
  )

  @professional_plan = create_plan(
    sku: "professional",
    name: "Professional Plan",
    price_in_dollars: 79,
    short_description: "Enjoy every feature at your disposal.",
    description: "A long description.",
    featured: true
  )

  @discounted_annual_plan = create_plan(
    sku: Plan::DISCOUNTED_ANNUAL_PLAN_SKU,
    name: "Discounted Annual Plan",
    price_in_dollars: 175,
    short_description: "Everything you're used to, but a bit cheaper.",
    description: "A long description.",
    featured: false,
    annual: true
  )

  @free_plan = create_plan(
    sku: "free",
    name: "Free Plan",
    price_in_dollars: 0,
    short_description: "Totally free plan.",
    description: "A long description.",
    featured: false
  )
end

def create_plan(options={})
  Plan.create! options
end

def create_admin
  @admin = User.create!(
    email: ENV["ADMIN_ACCOUNT_INITIAL_EMAIL_ADDRESS"],
    password: ENV["ADMIN_ACCOUNT_INITIAL_PASSWORD"],
    first_name: "Liam",
    last_name: "Neeson",
    role: "super_admin"
  )
end

def checkout_admin(user)
  checkout = @free_plan.checkouts.build(
    user: user,
    email: user.email
  )
  checkout.fulfill
end
