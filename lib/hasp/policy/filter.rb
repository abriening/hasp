module Hasp
  module Policy
    module Filter
      def filter(current_user, collection)
        new(current_user, nil).filter(collection)
      end
    end
  end
end
