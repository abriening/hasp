module Hasp
  module Controller
    module Helper
      def policy_authorizes(model, action=action_name, policy=nil)
        controller.policy(model, policy).authorizes?(action)
      end
    end

    def self.included(controller)
      controller.class_eval do
        helper_method :policy
        helper_method :policy_filter
        helper Hasp::Controller::Helper
      end
    end

    def policy(model, policy=nil)
      (policy || policy_class).new(current_user, model)
    end

    def policy_filter(collection, policy=nil)
      (policy || policy_class).filter(current_user, collection)
    end

    def policy_class
      name = "#{self.class.name.demodulize.sub(/Controller$/, '').singularize}Policy"
      if Object.const_defined? name
        Object.const_get(name)
      else
        Hasp::DefaultPolicy
      end
    end
  end
end
