module MyCli
  class CommandRegistry
    @commands = {}

    class << self
      attr_reader :commands

      def register(name, klass, description: nil)
        @commands[name] = { class: klass, description: description }
      end

      def fetch(name)
        entry = @commands[name]

        raise "Invalid command. #{MyCli::Utils::MyOptionParser::HELP_STRING}" unless entry

        entry[:class]
      end
    end
  end
end
