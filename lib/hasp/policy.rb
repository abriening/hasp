module Hasp
  module Policy
    module Filter
      def filter(current_user, collection)
        collection
      end
    end

    def self.included(policy)
      unless policy.methods.include?(:filter)
        policy.extend Filter
      end
      Hasp.policies << policy
    end

    def self.select(name)
      return if name.nil?
      Hasp.policies.detect do |policy|
        policy.name =~ %r!^#{name}!
      end
    end

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

    def authorizes?(action)
      if respond_to? action
        send action
      else
        false
      end
    end

    def authorizes!(action)
      authorizes?(action) || raise(Hasp::AccessDenied)
    end

    def filter(collection)
      self.class.filter(current_user, collection)
    end
  end
end
