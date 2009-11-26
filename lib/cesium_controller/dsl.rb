module CesiumController
  module Dsl

    def self.included base
      base.class_eval do
        extend ClassMethods
      end
    end

    [:index, :show, :form].each do |sym|
      define_method("#{sym}_fields") do
        self.class.terbium_fields[sym]
      end
    end

    def field_exists? order
      if order.include? '.'
        match = order.scan(/\A(\w+)\.(\w+)\Z/)[0]
        mod = match[0].classify.constantize
        col = match[1]
      else
        mod = model
        col = order
      end
      mod && mod.columns.detect { |c| c.name == col }
    end

    module ClassMethods

      [:index, :show, :form].each do |sym|
        class_eval <<-EOS
          def #{sym}
            @terbium_option = :#{sym}
            yield if block_given?
          end
        EOS
      end

      def field name, options = {}
        @terbium_fields = {} unless @terbium_fields
        @terbium_fields[@terbium_option] = [] unless @terbium_fields[@terbium_option]
        @terbium_fields[@terbium_option] << ::Terbium::Field.new(name, options)
      end

      def terbium_fields
        @terbium_fields
      end

    end

  end
end
