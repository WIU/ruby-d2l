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

    # = EnrollUser
    # REQUIRED:: { :org_unit_id => "ID, ":user_id => "ID", :role_id => "ID" }
    # RETURNS::
    def self.enroll_user(params = {})
      required_params(params, [:org_unit_id, :user_id, :role_id])

      params = {
        org_unit_id: '',
        user_id: '',
        role_id: ''
      }.merge(params)

      token = RubyD2L::Auth.get_token

      the_xml = '<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Header>
        <RequestHeader xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">
          <Version>1.0</Version>
          <CorellationId>12345</CorellationId>
          <AuthenticationToken>' + token + '</AuthenticationToken>
        </RequestHeader>
        </soap:Header>
        <soap:Body>
          <EnrollUserRequest xmlns="http://www.desire2learn.com/services/ums/wsdl/UserManagementService-v1_0">
            <OrgUnitId>
              <Id xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">' + params[:org_unit_id] + '</Id>
              <Source xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">Desire2Learn</Source>
            </OrgUnitId>
            <UserId>
              <Id xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">' + params[:user_id] + '</Id>
              <Source xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">Desire2Learn</Source>
            </UserId>
            <RoleId>
              <Id xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">' + params[:role_id] + '</Id>
              <Source xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">Desire2Learn</Source>
            </RoleId>
          </EnrollUserRequest>
        </soap:Body>
      </soap:Envelope>'

      enrollment = connect(RubyD2L.site_url).request :enroll_user do
        soap.xml = the_xml
      end

      if enrollment.to_hash.include?(:enroll_user_response)
        response = enrollment.to_hash[:enroll_user_response]
        response_hash = Tools.get_all_values_nested(response)
        if response_hash.keys.any? { |k| k.include? 'business_errors' }
          return response_hash.keep_if { |k, _v| k.include? 'business_errors' }
        else
          return response_hash
        end
      else
        return false
      end
    end

    # = EnrollUser
    # REQUIRED:: N/A
    # RETURNS::  Array of roles
    def self.get_roles
      token = RubyD2L::Auth.get_token

      the_xml = '<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Header>
         <RequestHeader xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">
           <Version>1.0</Version>
           <CorellationId>12345</CorellationId>
           <AuthenticationToken>' + token + '</AuthenticationToken>
         </RequestHeader>
        </soap:Header>
        <soap:Body>
          <GetRolesRequest xmlns="http://www.desire2learn.com/services/ums/wsdl/UserManagementService-v1_0" />
        </soap:Body>
      </soap:Envelope>'

      roles = connect(RubyD2L.site_url).request :get_roles do
        soap.xml = the_xml
      end

      response = roles.to_hash[:get_roles_response]
      @role_info = []
      if response.include?(:roles)
        response[:roles][:role_info].each do |r|
          @role_info << Tools.get_all_values_nested(r)
        end
        return @role_info
      else
        return false
      end
    end

    def self.get_user_by_user_name(params = {})
      required_params(params, :user_name)

      params = {
        user_name: ''
      }.merge(params)

      token = RubyD2L::Auth.get_token

      the_xml = '<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Header>
         <RequestHeader xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">
           <Version>1.0</Version>
           <CorellationId>12345</CorellationId>
           <AuthenticationToken>' + token + '</AuthenticationToken>
         </RequestHeader>
        </soap:Header>
        <soap:Body>
          <GetUserByUserNameRequest xmlns="http://www.desire2learn.com/services/ums/wsdl/UserManagementService-v1_0">
            <UserName>' + params[:user_name] + '</UserName>
          </GetUserByUserNameRequest>
        </soap:Body>
      </soap:Envelope>'

      user = connect(RubyD2L.site_url).request :get_user_by_user_name do
        soap.xml = the_xml
      end

      # ap user.to_hash
      #   exit

      response = user.to_hash[:get_user_response]
      if response.include?(:user)
        return Tools.get_all_values_nested(response)
      else
        return false
      end
    end

    def self.required_params(passed_params = {}, *args)
      required_params = *args[0]
      required_params.each do |key|
        fail ArgumentError.new("MISSING PARAM -- :#{key} parameter is required!") unless passed_params.key?(key)
      end
    end
  end
end
