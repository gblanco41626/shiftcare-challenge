require 'optparse'

module MyCli
  module Utils
    class MyOptionParser

      def self.parse(argv)
        options = {}

        parser = OptionParser.new do |opts|
          opts.banner = 'Usage: bin/shiftcare_challenge <command> [options]'
          opts.separator ''
          opts.separator 'Commands:'
          opts.separator '  search            Search clients by name'
          opts.separator '  find-duplicate    Find duplicate emails'
          opts.separator ''
          opts.separator 'Options:'

          opts.on('-f', '--file FILE', 'Specify a remote or local JSON file') do |file|
            options[:file] = file
          end

          opts.on('-q', '--query URL', 'Search query (for search command)') do |query|
            options[:query] = query
          end

          opts.on('-h', '--help', 'Show this help message') do
            puts opts
            exit
          end

          opts.parse!(argv)
        end

        options
      end
    end
  end
end
