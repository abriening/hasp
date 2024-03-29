require_relative './test_helper.rb'

class PolicyTest < MiniTest::Unit::TestCase
  def setup
    @current_user = User.new
    @account = Account.new(@current_user)
    @policy = AccountPolicy.new(@current_user, @account)
  end

  def test_policy_deafult_applies_to_any_rule
    @policy_class = Class.new(Hasp::DenyPolicy) do
      def default; true; end
    end
    @policy = @policy_class.new @current_user, @account
    assert_equal true, @policy.authorizes?(:read)
    assert_equal true, @policy.authorizes?(:new)
    assert_equal true, @policy.authorizes?(:patch)
  end

  def test_policy_all_applies_to_crud_rules
    @policy_class = Class.new(Hasp::DenyPolicy) do
      all do
        true
      end
    end
    @policy = @policy_class.new @current_user, @account
    assert_equal true, @policy.authorizes?(:read)
    assert_equal true, @policy.authorizes?(:new)
    assert_equal false, @policy.authorizes?(:patch)
  end

  def test_policy_all_can_use_instance_variables
    @policy_class = Class.new(Hasp::DenyPolicy) do
      all do
        current_user == model.user
      end
    end
    @policy = @policy_class.new @current_user, @account
    assert_equal true, @policy.authorizes?(:read)
    @policy.model.user = nil
    assert_equal false, @policy.authorizes?(:read)
  end

  def test_inherited_policy_is_added_to_policies
    policy = Class.new(AccountPolicy)
    assert_includes Hasp.policies, policy
  end

  def test_policy_select
    assert_equal AccountPolicy, Hasp::Policy.select(Account.name)
    assert_equal UserPolicy, Hasp::Policy.select(User.name)
    assert_nil Hasp::Policy.select(Object.name)
    assert_nil Hasp::Policy.select(nil)
  end

  def test_authorizes?
    assert_equal true, @policy.authorizes?(:read)
    assert_equal false, @policy.authorizes?(:destroy)
    @policy.current_user = nil
    assert_equal false, @policy.authorizes?(:read)
  end

  def test_authorizes_does_not_check_object_methods
    assert_equal false, @policy.authorizes?(:trust)
    assert_equal false, @policy.authorizes?(:to_s)
    assert_equal false, @policy.authorizes?(:send)
  end

  def test_authorize_aliases
    assert_equal true, @policy.authorizes?(:show)
    assert_equal true, @policy.authorizes?(:index)
  end

  def test_authorize_non_existing_actions
    assert_equal false, @policy.authorizes?(:edit)
    assert_equal false, @policy.authorizes?(:shovel)
  end

  def test_authorizes!
    assert_equal true, @policy.authorizes!(:read)
    assert_raises Hasp::AccessDenied do
      @policy.authorizes! :destroy
    end
  end

  def test_filter
    assert_equal [1,2,3], @policy.filter([1,2,3])
    @policy.current_user = nil
    assert_equal [], @policy.filter([1,2,3])
    assert_equal [], AccountPolicy.filter(nil, [1,2,3])
  end

  def test_filters_without_defining_filter_method
    @policy = Struct.new(:current_user, :account){ include Hasp::Policy }.new @current_user, @account
    assert_equal [1,2,3], @policy.filter([1,2,3])
  end
end
