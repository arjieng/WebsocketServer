module Exceptions

  class UnauthorizedException < StandardError
    def initialize(data)
      @data = data
    end
  end

end