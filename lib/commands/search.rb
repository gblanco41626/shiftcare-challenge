require_relative './base_command'

module MyCli
  module Commands
    class Search < BaseCommand

      MyCli::CommandRegistry.register(
        'search',
        self,
        description: 'Search clients by full name'
      )

      def initialize(options)
        super(options)

        @query = @options[:query]
      end

      def validate
        super

        if @query.nil? || @query.strip.empty?
          puts "Error: Please provide --query. #{MyCli::Utils::MyOptionParser::HELP_STRING}"
          exit 1
        end
      end

      def execute
        results = clients.select do |client|
          client['full_name'].downcase.include?(@query.downcase)
        end

        results.map { |res| res['full_name'] }
      end

    end
  end
end
