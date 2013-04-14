module Hasp
  class AllowPolicy < Struct.new(:current_user, :model)
    include Policy

    def read
      true
    end

    def create
      true
    end

    def update
      true
    end

    def destroy
      true
    end
  end
end
