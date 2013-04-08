module Hasp
  class DenyPolicy < Struct.new(:current_user, :model)
    include Policy
    extend Filter
  end
end
