module Terbium
  class Field < Object

    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options
    end

    def order
      if options[:order]
        options[:order].to_s
      else
        if @name.to_s.include? '.'
          match = @name.to_s.scan(/\A(\w+)\.(\w+)\Z/)[0]
          "#{match[0].tableize}.#{match[1]}"
        else
          @name.to_s
        end
      end
    end

    def [](key)
      @options[key]
    end

    def to_s
      @name.to_s
    end

  end
end
