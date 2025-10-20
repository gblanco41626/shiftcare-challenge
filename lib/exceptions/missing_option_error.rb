module MyCli
  module Exceptions
    class MissingOptionError < StandardError

      def initialize(key)
        super("Error: Please provide --#{key}")
      end

    end
  end
end
