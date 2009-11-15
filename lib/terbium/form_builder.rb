module Terbium
  module FormBuilder

    def terbium_field field
      type = field[:type] || @object.class.columns.detect { |c| c.name == field.to_s }.type
      case type
        #when :integer                then
        #when :float                  then
        #when :decimal                then
        when :date                   then terbium_date field
        when :time                   then terbium_time field
        when :datetime, :timestamp   then terbium_date_time field
        when :text                   then terbium_text_area field
        when :boolean                then terbium_check_box field
        when :binary                 then ''
        when :file                   then terbium_file_field field
        else                         terbium_text_field field
      end
    end

    def terbium_html field, control, options = {}
      <<-HTML
        <div #{"class=\"#{options[:class]}\"" if options[:class]}>
          #{terbium_label(field)}
          #{control}
        </div>
      HTML
    end

    def terbium_label field
      field[:label] ? label(field, field[:label]) : label(field)
    end

    def terbium_text_area field
      terbium_html field, text_area(field)
    end

    def terbium_check_box field
      <<-HTML
        <div class="checkbox">
          #{check_box(field)}
          #{terbium_label(field)}
        </div>
      HTML
    end

    def terbium_file_field field
      input = file_field(field)
      terbium_html field, input
    end

    def terbium_text_field field
      if @object.class.respond_to?("#{field}_select")
        input = select(field, @object.class.send("#{field}_select"))
      else
        input = text_field(field)
      end
      terbium_html field, input
    end

    def terbium_date_time field
      input = respond_to?(:calendar_date_select) ? calendar_date_select(field) : datetime_select(field)
      terbium_html field, input, :class => 'calendar'
    end

    def terbium_date field
      input = respond_to?(:calendar_date_select) ? calendar_date_select(field) : date_select(field)
      terbium_html field, input, :class => 'calendar'
    end

    def terbium_time field
      terbium_html field, time_select(field), :class => 'calendar'
    end

  end
end
