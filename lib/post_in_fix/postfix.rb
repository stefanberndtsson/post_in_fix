require 'post_in_fix/operator'

module PostInFix
  class Postfix
    def initialize(postfix_array)
      @pf = postfix_array
    end

    def to_solr
      stack = []
      @pf.each do |entry|
        if entry.is_a?(Operator)
          right = stack.pop
          left = stack.pop
          stack.push(entry.solr_apply(left, right))
        else
          stack.push(entry)
        end
      end
      stack.pop
    end
  end
end
