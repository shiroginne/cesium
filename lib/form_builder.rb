module ActionView
  module Helpers
    class FormBuilder

      def abstract_field field
        if @template.controller.respond_to? :column_types
          type = @template.controller.column_types[0][field] || @object.class.columns.detect {|c| c.name == field.to_s}.type
        else
          type = @object.class.columns.detect {|c| c.name == field.to_s}.type
        end
        case type
#          when :integer   then
#          when :float     then
#          when :decimal   then
#          when :binary    then
          when :date                   then terbium_date field
          when :time                   then terbium_time field
          when :datetime, :timestamp   then terbium_date_time field
          when :text                   then terbium_text_area field
          when :boolean                then terbium_check_box field
          when :binary                 then ''
          else                         terbium_text_field field
        end
      end

      def terbium_text_area field
        <<-HTML
          <div>
            #{label(field)}
            #{text_area(field)}
          </div>
        HTML
      end

      def terbium_check_box field
        <<-HTML
          <div class="checkbox">
            #{check_box(field)}
            #{label(field)}
          </div>
        HTML
      end

      def terbium_text_field field
        if @object.class.respond_to?("#{field}_select")
          input = select(field, @object.class.send("#{field}_select"))
        elsif @template.controller.respond_to?(:file_fields) && @template.controller.file_fields.include?(field)
          input = file_field(field)
        else
          input = text_field(field)
        end
        <<-HTML
          <div>
            #{label(field)}
            #{input}
          </div>
        HTML
      end

      def terbium_date_time field
        input = respond_to?(:calendar_date_select) ? calendar_date_select(field) : datetime_select(field)
        <<-HTML
          <div class="calendar">
            #{label(field)}
            #{input}
          </div>
        HTML
      end

      def terbium_date field
        input = respond_to?(:calendar_date_select) ? calendar_date_select(field) : date_select(field)
        <<-HTML
          <div class="calendar">
            #{label(field)}
            #{input}
          </div>
        HTML
      end
      
      def terbium_time field
        <<-HTML
          <div class="calendar">
            #{label(field)}
            #{time_select(field)}
          </div>
        HTML
      end

    end
  end
end
