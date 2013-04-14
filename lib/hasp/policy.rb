module Hasp
  module Policy
    module Filter
      def filter(current_user, collection)
        new(current_user, nil).filter(collection)
      end
    end
    module Aliases
      def show
        authorizes? :read
      end

      def index
        authorizes? :read
      end

      def new
        authorizes? :create
      end

      def edit
        authorizes? :update
      end
    end

    include Aliases

    def self.included(policy)
      unless policy.methods.include?(:filter)
        policy.extend Filter
      end
      Hasp.policies << policy
    end

    def self.rules(policy)
      return Aliases.public_instance_methods(false) unless policy < Hasp::Policy
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
