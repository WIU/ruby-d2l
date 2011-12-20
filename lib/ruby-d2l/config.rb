module RubyD2L
  module Config
    attr_accessor :username
    
    attr_accessor :password
    
    attr_accessor :site_url
    
    def reset_config!
      self.username = nil
      self.password = nil
      self.site_url = nil
    end
    
  end
end