require 'savon'

module RubyD2L
  class Auth

    def self.connect(site_url)
      Savon::Client.new do
        wsdl.document = "#{site_url}/d2l/AuthenticationTokenService.asmx?WSDL"
        wsdl.endpoint = "#{site_url}/d2l/AuthenticationTokenService.asmx"
        #http.proxy = @@proxy_server if @@proxy_server != nil
        http.auth.ssl.verify_mode = :none
      end
    end

    def list_soap_actions(params)
      site_url = params[0]
      # Get available SOAP actions
      ap connect(site_url).wsdl.soap_actions
  
      # [
      #     [0] :authenticate,
      #     [1] :authenticate2,
      #     [2] :authenticate_with_app_token
      # ]
  
    end


    def self.get_token
      username = RubyD2L.username
      password = RubyD2L.password
      # RETURNS THE AUTH TOKEN
      response = self.connect(RubyD2L.site_url).request :authenticate do
        soap.xml = '<?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <AuthenticateRequest xmlns="http://desire2learn.com/security/token/2007/08">
              <username>'+ username +'</username>
              <password>'+ password +'</password>
              <purpose>Web Service</purpose>
            </AuthenticateRequest>
          </soap:Body>
        </soap:Envelope>'
      end

      token = response.to_hash[:authenticate_response][:token]
  
    end
  
  
  end
end