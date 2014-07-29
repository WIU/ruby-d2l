require 'ruby-d2l/version'

module RubyD2L
  # Config
  module Config
    USER_AGENT  = "D2L Ruby Gem #{RubyD2L::VERSION}"

    attr_accessor :api_id

    attr_accessor :api_key

    attr_accessor :user_id

    attr_accessor :user_key

    attr_accessor :site_url

    def reset_config!
      self.api_id = nil
      self.api_key = nil
      self.user_id = nil
      self.user_key = nil
      self.site_url = nil
    end
  end
end
