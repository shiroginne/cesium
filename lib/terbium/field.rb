module Terbium
  class Field < Object

    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options
    end

    def order
      (options[:order] || name).to_s
    end

    def [](key)
      @options[key]
    end

    def to_s
      @name.to_s
    end

  end
end
