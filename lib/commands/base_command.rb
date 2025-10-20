module MyCli
  module Commands
    class BaseCommand

      def initialize(options)
        @options = options
      end

      def run
        results = execute

        puts results.empty? ? 'No results found' : results
      rescue => e
        puts "Error: #{e.message}"
        exit 1
      end

      def validate
        if @options[:file].nil?
          puts "Error: Please provide --file. #{MyCli::Utils::MyOptionParser::HELP_STRING}"
          exit 1
        end
      end

      def clients
        Services::JsonFetcher.fetch(@options[:file])
      end

      def execute
        raise NotImplementedError, "Subclasses must implement 'execute'"
      end

    end
  end
end
