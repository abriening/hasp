module Hasp
  VERSION = "0.0.0" unless defined?(VERSION)

  class AccessDenied < StandardError; end

  autoload :Policy, "hasp/policy"
  autoload :DefaultPolicy, "hasp/default_policy"
  autoload :Controller, "hasp/controller"

  def self.policies
    @policies ||= []
  end
end
