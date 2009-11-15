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
