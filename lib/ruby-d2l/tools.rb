class Tools
  
  @path = []
  
  @all_values = {}
   
  def self.get_all_values_nested(nested_hash={}) 
    nested_hash.each_pair do |k,v|
      @path << k
      case v
        when Array, DateTime, FalseClass, Fixnum, NilClass, String, TrueClass then 
          @all_values.merge!({"#{@path.join(".")}" => "#{v}"}) 
          @path.pop
        when Hash then get_all_values_nested(v)
        else raise ArgumentError, "Unhandled type #{v.class}"
      end
    end
    @path.pop

    return @all_values
  end
  
end
