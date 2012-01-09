class Tools
  
  # @path = []
  #  
  # def self.get_all_values_nested(nested_hash={}) 
  #   @all_values = {}
  #       
  #   nested_hash.each_pair do |k,v|
  #     @path << k
  #     case v
  #       when Array, DateTime, FalseClass, Fixnum, NilClass, String, TrueClass then 
  #         @all_values.merge!({"#{@path.join(".")}" => "#{v}"}) 
  #         @path.pop
  #       when Hash then get_all_values_nested(v)
  #       else raise ArgumentError, "Unhandled type #{v.class}"
  #     end
  #   end
  #   @path.pop
  # 
  #   return @all_values
  # end
  
  def self.get_all_values_nested(nested_hash={})
      @all_values = _get_all_values_nested(nested_hash)
  end
    
  def self._get_all_values_nested(nested_hash={}, path=[])
      all_values = {}
      nested_hash.each_pair do |k,v|
        path << k
        case v
          when Array, DateTime, FalseClass, Fixnum, NilClass, String, TrueClass then
            all_values.merge!({"#{path.join(".")}" => "#{v}"})
          when Hash then
            all_values.merge!(_get_all_values_nested(v, path))
          else
            raise ArgumentError, "Unhandled type #{v.class}"
        end
        path.pop
       end
       return all_values
  end
  
end
