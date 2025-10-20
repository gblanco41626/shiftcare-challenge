require_relative 'cli'
require_relative 'command_registry'
require_relative 'services/json_fetcher'
require_relative 'utils/my_option_parser'
require_relative 'exceptions/missing_option_error'

Dir[File.join(__dir__, 'commands', '*.rb')].sort.each { |file| require file }

module MyCli
end
