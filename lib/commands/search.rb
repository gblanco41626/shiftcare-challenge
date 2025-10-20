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

      def execute
        results = clients.select do |client|
          client['full_name'].downcase.include?(@query.downcase)
        end

        results.map { |res| res['full_name'] }
      end

      def required_options
        [:file, :query]
      end

    end
  end
end
