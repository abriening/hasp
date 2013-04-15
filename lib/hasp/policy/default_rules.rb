module Hasp
  module Policy
    module DefaultRules
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
  end
end
