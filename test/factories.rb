FactoryGirl.define do

  sequence :code do |n|
    "code#{n}"
  end

  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :first_name do |n|
    "firstname#{n}"
  end

  sequence :last_name do |n|
    "lastname#{n}"
  end

  factory :coupon do
    amount 10
    code
    discount_type "percentage"

    factory :one_time_coupon do
      one_time_use_only true
    end
  end

  factory :plan do
    name I18n.t("shared.subscription.name")
    price_in_dollars 99
    sku "professional"
    short_description "A great Subscription"
    description "A long description"

    factory :basic_plan do
      sku Plan::LITE_PLAN_SKU
    end

    factory :discounted_annual_plan do
      sku Plan::DISCOUNTED_ANNUAL_PLAN_SKU
      annual true
    end

    trait :featured do
      featured true
    end

    trait :team do
      price_in_dollars 89
      name "Jumpstart for teams"
      sku "team_plan"
      includes_team true
      minimum_quantity 3
    end

    trait :annual do
      name "#{I18n.t("shared.subscription.name")} (Yearly)"
      price_in_dollars 990
      sku "professional-yearly"
      annual true
    end

    trait :with_annual_plan do
      association :annual_plan, factory: [:plan, :annual]
    end
  end

  factory :invitation, class: "Invitation" do
    email
    sender factory: :user
    team

    after :stub do |invitation|
      invitation.code = "abc"
    end

    trait :accepted do
      recipient factory: :user
      accepted_at { Time.now }
    end
  end

  factory :acceptance, class: "Acceptance" do
    invitation
    first_name
    last_name
    password "secret"

    initialize_with do
      new(invitation: invitation, attributes: attributes.except(:invitation))
    end
  end

  factory :team_group, class: "TeamGroup" do
    name "Google"
    association :subscription, factory: :team_subscription
  end

  factory :checkout do
    association :plan
    association :user
  end

  factory :user do
    email
    first_name
    last_name
    password "password"

    transient do
      subscription nil
    end

    factory :super_admin do
      role "super_admin"
    end

    factory :subscriber do
      with_subscription

      factory :basic_subscriber do
        plan { create(:basic_plan) }
      end
    end

    trait :with_stripe do
      stripe_customer_id "cus12345"
    end

    trait :with_subscription do
      stripe_customer_id "cus12345"

      transient do
        plan { create(:plan) }
      end

      after :create do |instance, attributes|
        instance.subscriptions << create(
          :subscription,
          plan: attributes.plan,
          user: instance
        )
      end
    end

    trait :with_full_subscription do
      with_subscription

      transient do
        plan do
          create(:plan)
        end
      end
    end

    trait :with_subscription_purchase do
      with_subscription

      after :create do |instance, attributes|
        instance.subscriptions << create(
          :subscription,
          :purchased,
          plan: attributes.plan,
          user: instance
        )
      end
    end

    trait :with_basic_subscription do
      stripe_customer_id "cus12345"

      after :create do |instance|
        plan = create(:basic_plan)
        create(:subscription, plan: plan, user: instance)
      end
    end

    trait :with_inactive_subscription do
      stripe_customer_id "cus12345"

      after :create do |instance|
        instance.subscriptions <<
          create(:inactive_subscription, user: instance)
      end
    end

    trait :with_inactive_team_subscription do
      stripe_customer_id "cus12345"
      team

      after :create do |instance|
        create(
          :inactive_subscription,
          user: instance,
          plan: create(:plan, :team),
          team: instance.team
        )
      end
    end

    trait :with_team_subscription do
      stripe_customer_id "cus12345"
      team

      after :create do |instance|
        subscription = create(
          :subscription,
          user: instance,
          plan: create(:plan, :team),
          team: instance.team
        )
        SubscriptionFulfillment.new(instance, subscription.plan).fulfill
      end
    end
  end

  factory :subscription, aliases: [:active_subscription] do
    association :plan
    association :user

    factory :inactive_subscription do
      deactivated_on { Time.zone.today }
    end

    factory :team_subscription do
      association :plan, factory: [:plan, :team]
    end

    trait :purchased do
      after :create do |subscription|
        create(
          :checkout,
          plan: subscription.plan,
          user: subscription.user
        )
      end
    end
  end

end
