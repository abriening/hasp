require 'minitest/autorun'

Account = Struct.new(:user)

class AccountPolicy < Struct.new(:current_user, :account)
  include Hasp::Policy

  def read
    current_user == account.user
  end

  def destroy
    false
  end

  def self.filter(current_user, collection)
    if current_user
      collection
    else
      []
    end
  end
end

class User; end

class UserPolicy < Struct.new(:current_user, :user)
  include Hasp::Policy

  def destroy
    true
  end
end

class AccountsController
  @@spy = []
  class << self
    def helper_method(x=nil)
      x ? @@spy << x : @@spy
    end
    alias_method :helper, :helper_method
    attr_accessor :name
  end

  include Hasp::Controller

  attr_accessor :current_user, :action_name
  def initialize(current_user, action_name)
    @current_user, @action_name = current_user, action_name
  end
end
