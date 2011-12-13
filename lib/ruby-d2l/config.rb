module RubyD2L
  module Config
    
    attr_writer :username
    
    attr_writer :password
    
    attr_writer :site_url
    
    def reset_config!
      self.username = nil
      self.password = nil
      self.site_url = nil
    end
    
  end
end