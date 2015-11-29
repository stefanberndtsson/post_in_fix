module PostInFix
  class Operator
    SOLR_OPERNAMES={
      "+" => "add",
      "-" => "sub",
      "/" => "div",
      "*" => "product"
    }

    def initialize(sign)
      @sign = sign
    end

    def solr_apply(left, right)
      "#{SOLR_OPERNAMES[@sign]}(#{left},#{right})"
    end

    def [](value)
      @sign[value]
    end

    def sign
      @sign
    end

    def inspect
      "OP<#{@sign}>"
    end

    def is_operator?
      ["+", "-", "/", "*"].include?(@sign)
    end
  end
end
