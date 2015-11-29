require 'post_in_fix/postfix'
require 'post_in_fix/operator'

module PostInFix
  class Infix
    def initialize(str)
      @str = str
    end

    def to_stack
      pflist = []
      pfstack = []
      last_chr = false
      sign_next_value = nil

      @str.split("").each do |chr|
        if chr[/[a-z0-9_.]/]
          if !last_chr
            pflist << ""
          end
          if sign_next_value == "-"
            pflist.last << "-"
          end
          pflist.last << chr
          last_chr = true
          sign_next_value = nil
        elsif chr[/[+-]/]
          if !value_near_top?(pflist)
            sign_next_value = chr
          else
            while pfstack.last && pfstack.last[/[*\/+-]/]
              pflist << pfstack.pop
            end
            pfstack.push(Operator.new(chr))
          end
          last_chr = false
        elsif chr[/[*\/]/]
          pfstack.push(Operator.new(chr))
          last_chr = false
        elsif chr[/[(]/]
          pfstack.push(Operator.new(chr))
          last_chr = false
        elsif chr[/[)]/]
          while pfstack.last && !pfstack.last[/[(]/]
            pflist << pfstack.pop
          end
          if pfstack.last && pfstack.last[/[(]/]
            pfstack.pop
          end
          last_chr = false
        end
      end
      while pfstack.last
        pflist << pfstack.pop
      end
      pflist.map do |entry|
        if entry.is_a?(String)
          if entry[/^[-+]?[0-9]+$/]
            entry = entry.to_i
          elsif entry[/^[-+]?[0-9]*\.?[0-9]+$/]
            entry = entry.to_f
          end
        end
        entry
      end
    end

    def to_postfix
      Postfix.new(to_stack)
    end

    def value_near_top?(stack)
      stack_value = stack.reverse.first
      return false if stack_value.is_a?(Operator)
      return false if stack_value.nil?
      true
    end
  end
end
