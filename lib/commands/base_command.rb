module MyCli
  module Commands
    class BaseCommand

      def initialize(options)
        @options = options
      end

      def run
        validate

        results = execute

        puts results.empty? ? 'No results found' : results
      rescue => e
        puts "Error: #{e.message}"
        exit 1
      end

      def validate
        required_options.each do |opt|
          key = opt.to_sym

          if @options[key].nil? || @options[key].strip.empty?
            raise Exceptions::MissingOptionError.new(key)
          end
        end
      end

      def clients
        Services::JsonFetcher.fetch(@options[:file])
      end

      def execute
        raise NotImplementedError, "Subclasses must implement 'execute'"
      end

      def required_options
        []
      end

    end
  end
end
