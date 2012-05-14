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

    # = CreateCourseOffering
    # Get a list of available SOAP actions for OrgUnit
    def self.list_soap_actions()

      ap connect(RubyD2L.site_url).wsdl.soap_actions
    
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
  
    # = AddChildOrgUnit
    # REQUIRED:: { :parent_id = "ID", :child_id => "ID" }
    # RETURNS::  
    def self.add_child_org_unit(params={})
      self.required_params(params, [:parent_id, :child_id])

      params = {
        :parent_id => "",
        :child_id => ""
      }.merge(params)
      
      token = RubyD2L::Auth.get_token
    
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
          <AddChildOrgUnitRequest xmlns="http://www.desire2learn.com/services/oums/wsdl/OrgUnitManagementService-v1_0">
            <OrgUnitId>
              <Id xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">'+ params[:parent_id] +'</Id>
              <Source xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">Desire2Learn</Source>
            </OrgUnitId>
            <ChildOrgUnitId>
              <Id xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">'+ params[:child_id] +'</Id>
              <Source xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">Desire2Learn</Source>
            </ChildOrgUnitId>
          </AddChildOrgUnitRequest>
        </soap:Body>
      </soap:Envelope>'
      
      add_child = self.connect(RubyD2L.site_url).request :add_child_org_unit do
        soap.xml = the_xml
      end
      
      if add_child.to_hash.include?(:add_child_org_unit_response)
        response = add_child.to_hash[:add_child_org_unit_response]
        response_hash = Tools.get_all_values_nested(response)
        if response_hash.keys.any? {|k| k.include? "business_errors"}
          return response_hash.keep_if {|k,v| k.include? "business_errors"}
        else
          return response_hash
        end
      else
        return false
      end
            
    end
    
    
    # = CreateCourseOffering
    # REQUIRED:: { :offering_name => "NAME", :offering_code => "CODE" }
    # OPTIONAL:: { :is_active => "true|false", :start_date => DateTime.to_s (e.g. YYYYMMDDThh:mm:ss), :end_date => DateTime.to_s (e.g. YYYYMMDDThh:mm:ss) }
    # NOT IMPLEMENTED::  I don't use <Path>'+ @course_path +'</Path>.  Add it if you need it.
    def self.create_course_offering(params={})
      self.required_params(params, [:offering_name, :offering_code, :template_id])
      
      params = {
        :offering_name => "",
        :offering_code => "",
        :template_id => "",
        :is_active => "false",
        :start_date => DateTime.now.to_s,
        :end_date => DateTime.now.to_s,
        :can_register => "false",
        :allow_sections => "false"
      }.merge(params)
    
      token = RubyD2L::Auth.get_token
    
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
            <Name>'+ params[:offering_name] +'</Name>
            <Code>'+ params[:offering_code] +'</Code>
            <TemplateId>
              <Id xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">'+ params[:template_id] +'</Id>
              <Source xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">Desire2Learn</Source>
            </TemplateId>
            <IsActive>'+ params[:is_active] +'</IsActive>
            <StartDate>'+ params[:start_date] +'</StartDate>
            <EndDate>'+ params[:end_date] +'</EndDate>
            <CanRegister>'+ params[:can_register] +'</CanRegister>
            <AllowSections>'+ params[:allow_sections] +'</AllowSections>
          </CreateCourseOfferingRequest>
        </soap:Body>
      </soap:Envelope>'
      
      esc_xml = the_xml.gsub("&", "&amp;")
      
      create_offering = self.connect(RubyD2L.site_url).request :create_course_offering do
        soap.xml = esc_xml
      end
          
      response = create_offering.to_hash[:create_course_offering_response]
      if response.include?(:course_offering)
        return Tools.get_all_values_nested(response)
      else
        return false
      end
    end

    # = CreateCourseTemplate
    # REQUIRED:: { :template_name => "NAME", :template_code => "CODE" }
    # OPTIONAL:: { :is_active => "true|false", :start_date => DateTime.to_s (e.g. YYYYMMDDThh:mm:ss), :end_date => DateTime.to_s (e.g. YYYYMMDDThh:mm:ss) }
    def self.create_course_template(params={})
      self.required_params(params, [:template_name, :template_code])
      
      params = {
        :template_name => "",
        :template_code => "",
        :is_active => "false",
        :start_date => DateTime.now.to_s,
        :end_date => DateTime.now.to_s
      }.merge(params)
    
      token = RubyD2L::Auth.get_token
    
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
            <Name>'+ params[:template_name] +'</Name>
            <Code>'+ params[:template_code] +'</Code>
            <IsActive>'+ params[:is_active] +'</IsActive>
            <StartDate>'+ params[:start_date] +'</StartDate>
            <EndDate>'+ params[:end_date] +'</EndDate>
          </CreateCourseTemplateRequest>
        </soap:Body>
      </soap:Envelope>'
    
      esc_xml = the_xml.gsub("&", "&amp;")
      
      template = self.connect(RubyD2L.site_url).request :create_course_template do
        soap.xml = esc_xml
      end

      response = template.to_hash[:create_course_template_response]
      if response.include?(:course_template)
        return Tools.get_all_values_nested(response)
      else
        return false
      end
    end

    # = CreateSemester
    # REQUIRED:: { :semester_name => "NAME", :semester_code => "CODE" }
    # OPTIONAL:: { :is_active => "true|false", :start_date => DateTime.to_s (e.g. YYYYMMDDThh:mm:ss), :end_date => DateTime.to_s (e.g. YYYYMMDDThh:mm:ss) }
    def self.create_semester(params={})
      self.required_params(params, [:semester_name, :semester_code, :path])
      
      params = {
        :semester_name => "",
        :semester_code => "",
        :path => "",
        :is_active => "true",
        :start_date => DateTime.now.to_s,
        :end_date => DateTime.now.to_s
      }.merge(params)
    
      token = RubyD2L::Auth.get_token
    
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
          <CreateSemesterRequest xmlns="http://www.desire2learn.com/services/oums/wsdl/OrgUnitManagementService-v1_0">
            <Name>'+ params[:semester_name] +'</Name>
            <Code>'+ params[:semester_code] +'</Code>
            <Path>'+ params[:path] +'</Path>
            <IsActive>'+ params[:is_active] +'</IsActive>
            <StartDate>'+ params[:start_date] +'</StartDate>
            <EndDate>'+ params[:end_date] +'</EndDate>
          </CreateSemesterRequest>
        </soap:Body>
      </soap:Envelope>'
    
      esc_xml = the_xml.gsub("&", "&amp;")
      
      template = self.connect(RubyD2L.site_url).request :create_semester do
        soap.xml = esc_xml
      end

      response = template.to_hash[:create_semester_response]
      puts response
      if response.include?(:semester)
        return Tools.get_all_values_nested(response)
      else
        return false
      end
    end


    # = GetCourseOfferingByCode
    # REQUIRED:: offering_code => "CODE"
    # RETURNS::  false if not found, values hash if found
    def self.get_course_offering_by_code(params={})
      self.required_params(params, [:offering_code])
      
      params = {
        :offering_code => ""
      }.merge(params)

      token = RubyD2L::Auth.get_token
      
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
          <GetCourseOfferingByCodeRequest xmlns="http://www.desire2learn.com/services/oums/wsdl/OrgUnitManagementService-v1_0">
             <Code>'+ params[:offering_code] +'</Code>
          </GetCourseOfferingByCodeRequest>
        </soap:Body>
      </soap:Envelope>'
      
      offering = self.connect(RubyD2L.site_url).request :get_course_offering_by_code do
        soap.xml = the_xml
      end
    
      response = offering.to_hash[:get_course_offering_response]
      if response.include?(:course_offering)
        return Tools.get_all_values_nested(response)
      else
        return false
      end
      
    end
    
    
    # = GetCourseTemplateByCode
    # REQUIRED:: template_code => "CODE"
    # RETURNS::  false if not found, values hash if found
    def self.get_course_template_by_code(params={})
      self.required_params(params, [:template_code])
      
      params = {
        :template_code => ""
      }.merge(params)

      token = RubyD2L::Auth.get_token
      
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
            <Code>'+ params[:template_code] +'</Code>
          </GetCourseTemplateByCodeRequest>
        </soap:Body>
      </soap:Envelope>'
    
      template = self.connect(RubyD2L.site_url).request :get_course_template_by_code do
        soap.xml = the_xml
      end
    
      response = template.to_hash[:get_course_template_response]
      if response.include?(:course_template)
        return Tools.get_all_values_nested(response)
      else
        return false
      end            
    end
    
    # = GetChildCourseTemplates
    # REQUIRED:: org_unit_id => "ID"
    # RETURNS::  false if not found, values hash if found
    def self.get_child_course_templates(params={})
      self.required_params(params, [:org_unit_id])
            
      params = {
        :org_unit_id => ""
      }.merge(params)
      
      token = RubyD2L::Auth.get_token
      
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
            <GetChildCourseTemplatesRequest xmlns="http://www.desire2learn.com/services/oums/wsdl/OrgUnitManagementService-v1_0">
              <OrgUnitId>
                <Id xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">'+ params[:org_unit_id] +'</Id>
                <Source xmlns="http://www.desire2learn.com/services/common/xsd/common-v1_0">Desire2Learn</Source>
              </OrgUnitId>
            </GetChildCourseTemplatesRequest>
        </soap:Body>
      </soap:Envelope>'
      
      child_templates = self.connect(RubyD2L.site_url).request :get_child_course_templates do
        soap.xml = the_xml
      end
      
      response = child_templates.to_hash[:get_course_templates_response]
      
      if response.include?(:child_org_units)
        return Tools.get_all_values_nested(response)
      else
        return false
      end
            
    end
    
    # = GetDepartmentByCode
    # REQUIRED:: :org_unit_code => "CODE"
    # RETURNS::  false if not found, values hash if found
    def self.get_department_by_code(params={})
      self.required_params(params, [:org_unit_code])
            
      params = {
        :org_unit_code => ""
      }.merge(params)
      
      token = RubyD2L::Auth.get_token
      
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
          <GetDepartmentByCodeRequest xmlns="http://www.desire2learn.com/services/oums/wsdl/OrgUnitManagementService-v1_0">
            <Code>'+ params[:org_unit_code] +'</Code>
          </GetDepartmentByCodeRequest>
        </soap:Body>
      </soap:Envelope>'
      
      department = self.connect(RubyD2L.site_url).request :get_department_by_code do
        soap.xml = the_xml
      end
      
      response = department.to_hash[:get_department_response]

      if response.include?(:department)
        return Tools.get_all_values_nested(response)
      else
        return false
      end
      
    end
    
    # = GetSemesterByCode
    # REQUIRED:: :org_unit_code => "CODE"
    # RETURNS::  false if not found, values hash if found
    def self.get_semester_by_code(params={})
      self.required_params(params, [:semester_code])
            
      params = {
        :semester_code => ""
      }.merge(params)
      
      token = RubyD2L::Auth.get_token
      
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
          <GetSemesterByCodeRequest xmlns="http://www.desire2learn.com/services/oums/wsdl/OrgUnitManagementService-v1_0">
            <Code>'+ params[:semester_code] +'</Code>
          </GetSemesterByCodeRequest>
        </soap:Body>
      </soap:Envelope>'
      
      semester = self.connect(RubyD2L.site_url).request :get_semester_by_code do
        soap.xml = the_xml
      end
      
      response = semester.to_hash[:get_semester_response]

      if response.include?(:semester)
        return Tools.get_all_values_nested(response)
      else
        return false
      end
      
    end
    
    
    def self.required_params(passed_params={},*args)
      required_params = *args[0]
      required_params.each do |key|
        raise ArgumentError.new("MISSING PARAM -- :#{key} parameter is required!") unless passed_params.has_key?(key)
      end
    end
    
  end
end