module Hasp
  module Policy
    module Interface
      def inherited(policy)
        Hasp.policies << policy
      end

      def all(&block)
        [:create, :read, :update, :destroy].each do |method|
          define_method method, &block
        end
      end
    end
  end
end
