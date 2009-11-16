module Terbium
  class Field < Object

    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options
    end

    def order
      @order ||= table_column options[:order] || @name
    end

    def label
      @label ||= options[:label] || @name.to_s.humanize
    end

    def [](key)
      @options[key]
    end

    def to_s
      @name.to_s
    end

  private

    def table_column str
      if str.to_s.include? '.'
        match = str.to_s.scan(/\A(\w+)\.(\w+)\Z/)[0]
        "#{match[0].tableize}.#{match[1]}"
      else
        str.to_s
      end
    end

  end
end
