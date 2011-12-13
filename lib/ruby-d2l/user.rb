require "savon"

module RubyD2L
  class User

    def self.connect(site_url)
      Savon::Client.new do
        wsdl.document = "#{site_url}/D2LWS/UserManagementService-v1.asmx?WSDL"
        wsdl.endpoint = "#{site_url}/D2LWS/UserManagementService-v1.asmx"
        http.auth.ssl.verify_mode = :none
      end
    end

    def self.list_soap_actions(params)
      # Get available SOAP actions

      site_url = params[0]
      ap connect(site_url).wsdl.soap_actions
  
      # [
      #     [ 0] :get_active_course_offerings_ex,
      #     [ 1] :get_active_course_offerings,
      #     [ 2] :activate_users,
      #     [ 3] :deactivate_users,
      #     [ 4] :get_user_activation_status,
      #     [ 5] :create_auditor_relationship,
      #     [ 6] :remove_auditor_relationship,
      #     [ 7] :get_auditors,
      #     [ 8] :get_auditees,
      #     [ 9] :get_users_by_org_unit_role,
      #     [10] :create_user,
      #     [11] :delete_user,
      #     [12] :get_user,
      #     [13] :update_user,
      #     [14] :delete_user_by_user_name,
      #     [15] :delete_user_by_org_defined_id,
      #     [16] :get_user_by_user_name,
      #     [17] :get_user_by_org_defined_id,
      #     [18] :get_roles,
      #     [19] :get_role,
      #     [20] :change_password,
      #     [21] :enroll_user,
      #     [22] :unenroll_user,
      #     [23] :get_org_unit_enrollment,
      #     [24] :get_enrollments_by_org_unit,
      #     [25] :get_profile_by_user,
      #     [26] :get_profile_picture,
      #     [27] :update_profile,
      #     [28] :get_users_by_group,
      #     [29] :get_users_by_section,
      #     [30] :get_users_by_course_offerings_index,
      #     [31] :get_permitted_tasks_by_user_org_unit
      # ]
  
    end


    def self.get_user_by_user_name(params)
      site_url = params[0]
      token = params[1]
      if params[2] == nil || params[2] == "list_params"
        ap "[user_name] param required by get_user_by_user_name!"
        exit
      else
        user_name = params[2]
      end
    
      user = connect(site_url).request :get_user_by_user_name do
        soap.xml = '<?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Header>
            <RequestHeader xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">
              <Version>1.0</Version>
              <CorellationId>12345</CorellationId>
              <AuthenticationToken>'+ token +'</AuthenticationToken>
            </RequestHeader>
          </soap:Header>
          <soap:Body>
            <GetUserByUserNameRequest xmlns="http://www.desire2learn.com/services/ums/wsdl/UserManagementService-v1_0">
              <UserName>'+ user_name +'</UserName>
            </GetUserByUserNameRequest>
          </soap:Body>
        </soap:Envelope>'
      end
    end
  
  
  end
end