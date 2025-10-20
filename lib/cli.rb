require 'optparse'

module MyCli
  class Cli

    def self.start(argv)
      help = argv.include?('-h') || argv.include?('--help')

      command = argv.shift unless help
      options = MyCli::Utils::MyOptionParser.parse(argv)

      return if help

      my_command = MyCli::CommandRegistry.fetch(command).new(options)
      my_command.validate
      my_command.run
    rescue => e
      puts "Error: #{e.message}"
    end

  end
end
