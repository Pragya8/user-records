#config/initializers/rest_client.rb
require 'open-uri'

module OpenURI
  class << self
    alias original_open open

    def open(name, *rest, &block)
      if name.to_s =~ /^https:/
        ssl_options = { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE }
        original_open(name, ssl_options, *rest, &block)
      else
        original_open(name, *rest, &block)
      end
    end
  end
end
