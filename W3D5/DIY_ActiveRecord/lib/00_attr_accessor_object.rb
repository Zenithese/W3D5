class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      
      self.define_method name do
        self.instance_variable_get("@#{name}")
      end
      self.define_method "#{name}=" do |num = 1|
        self.instance_variable_set("@#{name}", num)
      end
    end   
  end
end
