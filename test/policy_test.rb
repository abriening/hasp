require_relative './test_helper.rb'

class PolicyTest < MiniTest::Unit::TestCase
  def setup
    @current_user = Object.new
    @account = Struct.new(:user).new(@current_user)
    @policy = AccountPolicy.new(@current_user, @account)
  end

  def test_authorizes?
    assert_equal true, @policy.authorizes?(:read)
    assert_equal false, @policy.authorizes?(:destroy)
    @policy.current_user = nil
    assert_equal false, @policy.authorizes?(:read)
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
