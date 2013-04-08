require_relative './test_helper.rb'

class HaspTest < MiniTest::Unit::TestCase
  def test_policies
    assert_includes Hasp.policies, AccountPolicy
    assert_includes Hasp.policies, UserPolicy
  end

  def test_default_policy
    assert_equal Hasp::DenyPolicy, Hasp.default_policy
  end

  def test_can_set_default_policy
    Hasp.default_policy = UserPolicy
    assert_equal UserPolicy, Hasp.default_policy
  ensure
    Hasp.default_policy = Hasp::DenyPolicy
  end

  def test_raises_if_default_policy_nil
    Hasp.default_policy = nil
    assert_raises Hasp::DefaultPolicyNotDefined do
      Hasp.default_policy
    end
  ensure
    Hasp.default_policy = Hasp::DenyPolicy
  end
end
