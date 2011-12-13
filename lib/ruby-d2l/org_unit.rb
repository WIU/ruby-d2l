module RubyD2L
  
  class OrgUnit
    def self.connect(site_url)
      Savon::Client.new do
        wsdl.document = "#{site_url}/D2LWS/OrgUnitManagementService-v1.asmx?WSDL"
        wsdl.endpoint = "#{site_url}/D2LWS/OrgUnitManagementService-v1.asmx"
        #http.proxy = @@proxy_server if @@proxy_server != nil
        http.auth.ssl.verify_mode = :none
      end
    end

    def self.list_soap_actions(params)
      # Get available SOAP actions

      site_url = params[0]
      ap connect(site_url).wsdl.soap_actions
    
      # [
      #     [ 0] :link_course_offering_to_navbar,
      #     [ 1] :link_course_offering_to_homepage,
      #     [ 2] :set_course_offering_colors,
      #     [ 3] :configure_course_offering_appearance,
      #     [ 4] :get_child_org_units,
      #     [ 5] :get_organization,
      #     [ 6] :get_system_org_unit_types,
      #     [ 7] :get_custom_org_unit_types,
      #     [ 8] :create_custom_org_unit_type,
      #     [ 9] :get_custom_org_unit_type,
      #     [10] :update_custom_org_unit_type,
      #     [11] :delete_custom_org_unit_type,
      #     [12] :create_custom_org_unit,
      #     [13] :get_custom_org_unit,
      #     [14] :get_custom_org_unit_by_code,
      #     [15] :update_custom_org_unit,
      #     [16] :delete_custom_org_unit,
      #     [17] :get_department_org_unit_type,
      #     [18] :create_department,
      #     [19] :get_department,
      #     [20] :get_department_by_code,
      #     [21] :update_department,
      #     [22] :delete_department,
      #     [23] :get_semester_org_unit_type,
      #     [24] :create_semester,
      #     [25] :get_semester,
      #     [26] :get_semester_by_code,
      #     [27] :update_semester,
      #     [28] :delete_semester,
      #     [29] :create_course_template,
      #     [30] :get_course_template,
      #     [31] :get_course_template_by_code,
      #     [32] :update_course_template,
      #     [33] :delete_course_template,
      #     [34] :create_course_offering,
      #     [35] :get_course_offering,
      #     [36] :get_course_offering_by_code,
      #     [37] :update_course_offering,
      #     [38] :delete_course_offering,
      #     [39] :get_group_types,
      #     [40] :get_group_type,
      #     [41] :create_group_type,
      #     [42] :update_group_type,
      #     [43] :delete_group_type,
      #     [44] :create_group,
      #     [45] :get_group,
      #     [46] :get_group_by_code,
      #     [47] :update_group,
      #     [48] :delete_group,
      #     [49] :create_section,
      #     [50] :get_section,
      #     [51] :get_section_by_code,
      #     [52] :update_section,
      #     [53] :delete_section,
      #     [54] :add_child_org_unit,
      #     [55] :remove_child_org_unit,
      #     [56] :get_child_org_unit_type_ids,
      #     [57] :get_child_org_unit_ids,
      #     [58] :get_parent_org_unit_ids,
      #     [59] :get_child_groups,
      #     [60] :get_child_groups_by_type,
      #     [61] :get_child_sections,
      #     [62] :get_child_course_offerings,
      #     [63] :get_child_course_templates,
      #     [64] :get_child_departments,
      #     [65] :get_child_semesters,
      #     [66] :get_child_custom_org_units,
      #     [67] :get_child_custom_org_units_by_type
      # ]
    end
  
    def self.create_course_offering(params)
    
      # I don't use <Path>'+ @course_path +'</Path>.  Add it if you need it.
      
      @course_name = ""
      @course_code = ""
      @course_path = ""
      @template_id = ""
      @is_active = "false"
      @start_date = DateTime.now.to_s
      @end_date = DateTime.now.to_s
      @can_register = "false"
      @allow_sections = "false"
    
        site_url = params[0]
        token = params[1]
        if params[2] == nil || params[2] == "list_params"
          ap "REQUIRED: [course_name, course_code, template_id]"
          ap "OPTIONAL: [is_active(T/F), start_date (2011-12-12T00:00:00), end_date, can_register(T/F), allow_sections(T/F)]"
          ap "Must be comma separated with no spaces. (e.g. -p course_name=CS100,course_code=123,is_active=false)"
          exit
        else
          params[2].split(',').each do |values|
            vals = values.split('=')
            instance_variable_set("@#{vals[0]}", vals[1])
          end
        end

        the_xml = '<?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Header>
            <RequestHeader xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">
              <Version>1.0</Version>
              <CorellationId>12345</CorellationId>
              <AuthenticationToken>'+ token +'</AuthenticationToken>
            </RequestHeader>
          </soap:Header>
          <soap:Body>
            <CreateCourseOfferingRequest xmlns="http://www.desire2learn.com/services/oums/wsdl/OrgUnitManagementService-v1_0">
              <Name>'+ @course_name +'</Name>
              <Code>'+ @course_code +'</Code>
              <TemplateId>
                <Id xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">'+ @template_id +'</Id>
                <Source xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">Desire2Learn</Source>
              </TemplateId>
              <IsActive>'+ @is_active +'</IsActive>
              <StartDate>'+ @start_date +'</StartDate>
              <EndDate>'+ @end_date +'</EndDate>
              <CanRegister>'+ @can_register +'</CanRegister>
              <AllowSections>'+ @allow_sections +'</AllowSections>
            </CreateCourseOfferingRequest>
          </soap:Body>
        </soap:Envelope>'
      
        orgunit = connect(site_url).request :create_course_offering do
          soap.xml = the_xml
        end
            
    end

    def self.create_course_template(params)
    
      # I don't use <Path>'+ @template_path +'</Path>.  Add it if you need it.
    
      @template_name = ""
      @template_code = ""
      @is_active = "false"
      @start_date = DateTime.now.to_s
      @end_date = DateTime.now.to_s
    
      site_url = params[0]
      token = params[1]
      if params[2] == nil || params[2] == "list_params"
        ap "REQUIRED: [template_name, template_code]"
        ap "OPTIONAL: [is_active(true/false), start_date(YYYY-MM-DDThh:mm:ss), end_date(YYYY-MM-DDThh:mm:ss)]"
        ap "Must be comma separated with no spaces. (e.g. -p template_name=CS100,template_code=123,is_active=false)"
        exit
      else
        params[2].split(',').each do |values|
          vals = values.split('=')
          instance_variable_set("@#{vals[0]}", vals[1])
        end
      end
    
      the_xml = '<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Header>
          <RequestHeader xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">
            <Version>1.0</Version>
            <CorellationId>12345</CorellationId>
            <AuthenticationToken>'+ token +'</AuthenticationToken>
          </RequestHeader>
        </soap:Header>
        <soap:Body>
          <CreateCourseTemplateRequest xmlns="http://www.desire2learn.com/services/oums/wsdl/OrgUnitManagementService-v1_0">
            <Name>'+ @template_name +'</Name>
            <Code>'+ @template_code +'</Code>
            <IsActive>'+ @is_active +'</IsActive>
            <StartDate>'+ @start_date +'</StartDate>
            <EndDate>'+ @end_date +'</EndDate>
          </CreateCourseTemplateRequest>
        </soap:Body>
      </soap:Envelope>'
    
      template = connect(site_url).request :create_course_template do
        soap.xml = the_xml
      end
    
    
    end

    def self.get_course_template_by_code(template_code)
    
      # @template_code = ""
      token = RubyD2L::Auth.get_token
      
      # site_url = params[0]
      # token = params[1]
      #       if params[2] == nil || params[2] == "list_params"
      #         ap "REQUIRED: [template_code]"
      #         exit
      #       else
      #         params[2].split(',').each do |values|
      #           vals = values.split('=')
      #           instance_variable_set("@#{vals[0]}", vals[1])
      #         end
      #       end
    
      the_xml = '<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Header>
        <RequestHeader xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">
          <Version>1.0</Version>
          <CorellationId>12345</CorellationId>
          <AuthenticationToken>'+ token +'</AuthenticationToken>
        </RequestHeader>
        </soap:Header>
        <soap:Body>
          <GetCourseTemplateByCodeRequest xmlns="http://www.desire2learn.com/services/oums/wsdl/OrgUnitManagementService-v1_0">
            <Code>'+ template_code +'</Code>
          </GetCourseTemplateByCodeRequest>
        </soap:Body>
      </soap:Envelope>'
    
      template = self.connect(RubyD2L.site_url).request :get_course_template_by_code do
        soap.xml = the_xml
      end
    
    end
  end
end