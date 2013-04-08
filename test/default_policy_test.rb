require_relative './test_helper.rb'

class DefaultPolicyTest < MiniTest::Unit::TestCase
  def setup
    @current_user = User.new
    @account = Account.new(@current_user)
  end

  def test_allow_policy
    @policy = Hasp::AllowPolicy.new @current_user, @account
    assert_equal true, @policy.authorizes?(:read)
    assert_equal true, @policy.authorizes?(:create)
    assert_equal true, @policy.authorizes?(:update)
    assert_equal true, @policy.authorizes?(:destroy)
    assert_equal true, @policy.authorizes?(:show)
    assert_equal true, @policy.authorizes?(:index)
    assert_equal true, @policy.authorizes?(:edit)
    assert_equal true, @policy.authorizes?(:new)
  end

  def test_allow_policy_does_not_allow_non_defined_permissions
    @policy = Hasp::AllowPolicy.new @current_user, @account
    assert_equal false, @policy.authorizes?(:patch)
    assert_equal false, @policy.authorizes?(:purge)
  end

   def test_deny_policy
    @policy = Hasp::DenyPolicy.new @current_user, @account
    assert_equal false, @policy.authorizes?(:read)
    assert_equal false, @policy.authorizes?(:create)
    assert_equal false, @policy.authorizes?(:update)
    assert_equal false, @policy.authorizes?(:destroy)
    assert_equal false, @policy.authorizes?(:show)
    assert_equal false, @policy.authorizes?(:index)
    assert_equal false, @policy.authorizes?(:edit)
    assert_equal false, @policy.authorizes?(:new)
  end

  def test_deny_policy_does_not_allow_non_defined_permissions
    @policy = Hasp::DenyPolicy.new @current_user, @account
    assert_equal false, @policy.authorizes?(:patch)
    assert_equal false, @policy.authorizes?(:purge)
  end
end
