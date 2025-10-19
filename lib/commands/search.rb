require_relative './base_command'

module MyCli
  module Commands
    class Search < BaseCommand

      def initialize(command, options)
        super(command, options)

        @query = @options[:query]
      end

      def validate
        super

        if @query.nil? || @query.strip.empty?
          puts "Error: Please provide --query. #{HELP_STRING}"
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
