module Hasp
  module Policy
    module Collection
      def inherited(policy)
        Hasp.policies << policy
      end
    end
  end
end
