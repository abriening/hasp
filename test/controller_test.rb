require_relative './test_helper.rb'

class ControllerTest < MiniTest::Unit::TestCase
  def setup
    @current_user = User.new
    @account = Account.new(@current_user)
    @spy = AccountsController.class_variable_get(:@@spy)
    @controller = AccountsController.new(@current_user, 'show')
    @controller.class.name = 'AccountsController'

    @users_scope = [1,2,3]
    def @users_scope.klass; User; end

    @accounts_scope = [1,2,3]
    def @accounts_scope.klass; Account; end
  end

  def test_sets_helpers
    assert_includes @spy, :policy
    assert_includes @spy, :policy_filter
    assert_includes @spy, Hasp::Controller::Helper
  end

  def test_policy
    assert_kind_of AccountPolicy, @controller.policy(@account)
    assert_equal @current_user, @controller.policy(@account).current_user
    assert_equal @account, @controller.policy(@account).account
  end

  def test_policy_filter
    @controller.current_user = nil
    assert_equal [], @controller.policy_filter(@accounts_scope)
    assert_equal [1,2,3], @controller.policy_filter(@users_scope)
  end

  def view
    Struct.new(:controller, :action_name){ include Hasp::Controller::Helper }.new(@controller, 'show')
  end

  def test_policy_authorizes_helper
    assert_equal true, view.policy_authorizes(@account, 'show')
    assert_equal false, view.policy_authorizes(@account, 'destroy')
    assert_equal true, view.policy_authorizes(@current_user, 'destroy')
  end
end
