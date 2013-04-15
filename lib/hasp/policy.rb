module Hasp
  module Policy
    autoload :Filter, "hasp/policy/filter"
    autoload :Collection, "hasp/policy/collection"
    autoload :DefaultRules, "hasp/policy/default_rules"

    include DefaultRules

    def self.included(policy)
      unless policy.methods.include?(:filter)
        policy.extend Filter
      end
      policy.extend Collection
      Hasp.policies << policy
    end

    def self.rules(policy)
      return DefaultRules.public_instance_methods(false) unless policy < Hasp::Policy
      policy.public_instance_methods(false) | rules(policy.superclass)
    end

    def self.select(name)
      return if name.nil?
      Hasp.policies.detect do |policy|
        policy.name =~ %r!^#{name}!
      end
    end

    def authorizes?(action)
      if Hasp::Policy.rules(self.class).include?(action.to_sym)
        __send__ action
      else
        false
      end
    end

    def authorizes!(action)
      authorizes?(action) || raise(Hasp::AccessDenied)
    end

    def filter(collection)
      collection
    end
  end
end
