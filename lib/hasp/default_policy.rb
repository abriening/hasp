module Hasp
  class DefaultPolicy < Struct.new(:current_user, :model)
    include Policy
    extend Filter
  end
end
