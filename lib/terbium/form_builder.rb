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
        when :password               then terbium_password_field field
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
      label field, field.label
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

    def terbium_password_field field
      input = password_field(field)
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

    def codemirror_textarea method, options = {}
      script = <<-script
      <script type="text/javascript">
        var editor = CodeMirror.fromTextArea('#{@object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")}_#{method.to_s.sub(/\?$/,"")}', {
          parserfile: ["parsexml.js", "parsecss.js", "tokenizejavascript.js", "parsejavascript.js", "parsehtmlmixed.js"],
          stylesheet: ["/codemirror/css/xmlcolors.css", "/codemirror/css/jscolors.css", "/codemirror/css/csscolors.css"],
          path: "/codemirror/js/",
          lineNumbers: true
        });
      </script>
script
      '<div class="editor_border">' + text_area(method, options) + script + '</div>'
    end

  end
end
