module Hasp
  module Controller
    module Helper
      def policy_authorizes(model, action)
        controller.policy(model).authorizes?(action)
      end
    end

    def self.included(controller)
      controller.class_eval do
        helper_method :policy
        helper_method :policy_filter
        helper Hasp::Controller::Helper
      end
    end

    def policy(model)
      policy_class(model.class.name).new(current_user, model)
    end

    def policy_filter(collection)
      policy_class(collection.klass.name).filter(current_user, collection)
    end

    def policy_class(name)
      Hasp::Policy.select(name) || Hasp.default_policy
    end
  end
end
