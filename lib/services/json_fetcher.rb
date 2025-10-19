require 'json'
require 'open-uri'
require 'uri'

module MyCli
  module Services
    class JsonFetcher

      def self.fetch(path)
        data =
          if is_url?(path)
            URI.open(path).read
          else
            File.read(path)
          end

        JSON.parse(data)
      rescue => e
        []
      end

      def self.is_url?(url)
        uri = URI.parse(url)
        uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      rescue URI::InvalidURIError
        false
      end

    end
  end
end
