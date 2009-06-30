class Object
  def self.transmit_options *options
    options.each do |symbol|
      raise TypeError.new("method name is not symbol") unless symbol.is_a?(Symbol)
      class_eval <<-EOS
        def self.#{symbol} *fields
          define_method :#{symbol} do
            fields
          end
        end
      EOS
    end
  end
end
