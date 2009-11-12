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

class String
  def to_path_params
    self.split('/').delete_if { |x| x == "" }
  end

  def to_string_path_params
    "[#{self.to_path_params.map { |x| "\"#{x}\"" }.join(',')}]"
  end
end

class Array
  def build_tree_from_nested_set
    stack = Array.new
    stack.push first
    each do |item|
      item.child_pages = Array.new
      if item != first
        if item.level_cache > stack.last.level_cache
          stack.last.child_pages.push item
          stack.push item
        elsif item.level_cache == stack.last.level_cache
          stack.pop
          stack.push item
          stack[-2].child_pages.push item
        elsif item.level_cache < stack.last.level_cache
          begin
            stack.pop
          end until stack[-2].level_cache < item.level_cache
          stack.pop
          stack.push item
          stack[-2].child_pages.push item
        end
      end
    end
    first
  end
end

module ActionView
  module Helpers
    class FormBuilder
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
end

module CollectiveIdea
  module Acts
    module NestedSet
      module InstanceMethods
        def self_and_children
          [self] + children
        end
      end
    end
  end
end
