module Hasp
  class DenyPolicy < Struct.new(:current_user, :model)
    include Policy

    def filter(collection)
      []
    end
  end
end
