require_relative './test_helper.rb'

class ControllerTest < MiniTest::Unit::TestCase
  def setup
    @current_user = Object.new
    @account = Struct.new(:user).new(@current_user)
    @spy = AccountsController.class_variable_get(:@@spy)
    @controller = AccountsController.new(@current_user, 'show')
    @controller.class.name = 'AccountsController'
  end

  def test_sets_helpers
    assert_includes @spy, :policy
    assert_includes @spy, :policy_filter
    assert_includes @spy, Hasp::Controller::Helper
  end

  def test_policy_class
    assert_equal AccountPolicy, @controller.policy_class
    @controller.class.name = "Admin::AccountsController"
    assert_equal AccountPolicy, @controller.policy_class
    @controller.class.name = "FishController"
    assert AccountPolicy != @controller.policy_class
    assert Hasp::Policy > @controller.policy_class
  end

  def test_policy
    assert_kind_of AccountPolicy, @controller.policy(@account)
    assert_equal @current_user, @controller.policy(@account).current_user
    assert_equal @account, @controller.policy(@account).account
  end

  def test_policy_with_different_policy_class
    @user = Object.new
    assert_kind_of UserPolicy, @controller.policy(@user, UserPolicy)
    assert_equal @current_user, @controller.policy(@user, UserPolicy).current_user
    assert_equal @user, @controller.policy(@user, UserPolicy).user
  end

  def test_policy_filter
    @controller.current_user = nil
    assert_equal [], @controller.policy_filter([1,2,3])
  end

  def test_policy_filter_with_different_policy_class
    @controller.current_user = nil
    assert_equal [1,2,3], @controller.policy_filter([1,2,3], UserPolicy)
  end

  def view
    Struct.new(:controller, :action_name){ include Hasp::Controller::Helper }.new(@controller, 'show')
  end

  def test_policy_authorizes_helper
    assert_equal true, view.policy_authorizes(@account)
    assert_equal false, view.policy_authorizes(@account, 'destroy')
  end

  def test_policy_authorizes_helper_with_differnt_policy_class
    @user = Object.new
    assert_equal false, view.policy_authorizes(@user, 'create', UserPolicy)
    assert_equal true, view.policy_authorizes(@user, 'destroy', UserPolicy)
  end
end
