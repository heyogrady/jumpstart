require "test_helper"

class AnnualBillingsControllerTest < ActionController::TestCase

  def test_do_not_redirect_when_eligible_for_upgrade

  end

  def subscriber(eligible_for_annual_upgrade:)
    build_stubbed(:subscriber).tap do |user|
      if eligible_for_annual_upgrade
        
      end
    end
  end

end
