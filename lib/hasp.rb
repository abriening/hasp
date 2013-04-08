module Hasp
  VERSION = "0.0.0" unless defined?(VERSION)

  class AccessDenied < StandardError; end
  class DefaultPolicyNotDefined < StandardError; end

  autoload :Policy, "hasp/policy"
  autoload :AllowPolicy, "hasp/allow_policy"
  autoload :DenyPolicy, "hasp/deny_policy"
  autoload :Controller, "hasp/controller"

  class << self
    def policies
      @policies ||= []
    end

    attr_writer :default_policy
    def default_policy
      if defined?(@default_policy)
        @default_policy || raise(DefaultPolicyNotDefined)
      else
        DenyPolicy
      end
    end
  end
end
