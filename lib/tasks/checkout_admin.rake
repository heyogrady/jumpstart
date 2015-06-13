desc "Checkout for admin account"
task checkout_admin: :environment do
  user = User.find_by(email: "patrick@heyogrady.com")

  free_plan = Plan.find_by(sku: "free")

  checkout = free_plan.checkouts.build(
    user: user,
    email: user.email
  )
  checkout.fulfill

  puts "Checked out admin"
end
