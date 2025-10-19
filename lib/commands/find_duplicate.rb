require_relative './base_command'

module MyCli
  module Commands
    class FindDuplicate < BaseCommand

      def execute
        emails = clients.map { |client| client['email'] }.compact

        return [] if emails.empty?

        emails_count = emails.tally
        emails_count.keys.select { |email| emails_count[email] > 1 }
      end

    end
  end
end
