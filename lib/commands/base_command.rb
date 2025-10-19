module MyCli
  module Commands
    class BaseCommand

      HELP_STRING = 'Run with -h for help.'

      def self.build(command, options)
        klass = find_command_class(command)

        if klass.nil?
          puts "Invalid command. #{HELP_STRING}"
          exit 1
        end

        klass.new(command, options)
      end

      def initialize(command, options)
        @command = command
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
          puts "Error: Please provide --file. #{HELP_STRING}"
          exit 1
        end
      end

      def clients
        Services::JsonFetcher.fetch(@options[:file])
      end

      def execute
        raise NotImplementedError, "Subclasses must implement 'execute'"
      end

      private

      def self.find_command_class(command)
        subclasses.find do |klass|
          klass.name.split('::').last.downcase == command.gsub('-', '').downcase
        end
      rescue => e
        nil
      end

      def self.subclasses
        ObjectSpace.each_object(Class).select { |klass| klass < self }
      end

    end
  end
end
