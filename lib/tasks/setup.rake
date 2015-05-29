desc "Ensure that code is not running in production environment"
task :not_production do
  raise "do not run in production" if Rails.env.production?
end

desc "Sets up the project by running migration and populating sample data"
task setup: [:environment, :not_production, "db:drop", "db:create", "db:migrate"] do
  ["setup_sample_data"].each { |cmd| system "rake #{cmd}" }
end

def delete_all_records_from_all_tables
  ActiveRecord::Base.connection.schema_cache.clear!

  Dir.glob(Rails.root + "app/models/*.rb").each { |file| require file }

  ActiveRecord::Base.descendants.each do |klass|
    klass.reset_column_information
    klass.delete_all
  end
end

desc "Deletes all records and populates sample data"
task setup_sample_data: [:environment, :not_production] do
  delete_all_records_from_all_tables

  create_individual_plans
  create_users
  create_checkouts
  create_subscriptions
  create_team_plan

  puts "sample data was added successfully"
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

def create_users
  @sam = create_user(
    email: "sam@example.com",
    stripe_customer_id: "cus_6KHH7My7v8zu0P",
  )
end

def create_checkouts
  @sam_checkout = create_checkout(
    user: @sam,
    plan: @free_plan
  )
end

def create_subscriptions
  @sam_subscription = create_subscription(
    user: @sam,
    plan: @free_plan,
    plan_type: "Plan",
    next_payment_amount: 0,
    next_payment_on: Date.new(2016, 5, 28),
    stripe_id: "sub_6KHHMdzskL7gYL"
  )
end

def create_team_plan
  create_plan(
    sku: "team_plan",
    name: "Jumpstart for teams",
    price_in_dollars: 89,
    short_description: "A great subscription.",
    description: "A long description.",
    includes_team: true,
    minimum_quantity: 3
  )
end

def create_user(options={})
  user_attributes = {
    email: "sam@example.com",
    password: "welcome",
    first_name: "Sam",
    last_name: "Smith",
    role: "super_admin"
  }
  attributes = user_attributes.merge options
  User.create! attributes
end

def create_plan(options={})
  Plan.create! options
end

def create_checkout(options={})
  Checkout.create! options
end

def create_subscription(options={})
  Subscription.create! options
end

def checkout_user(user)
  checkout = @free_plan.checkouts.build(
    user: user,
    email: user.email
  )
  checkout.fulfill
end
