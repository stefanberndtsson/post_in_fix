require 'spec_helper'
require 'pp'

describe PostInFix do
  context "Infix" do
    it 'has a version number' do
      expect(PostInFix::VERSION).not_to be nil
    end

    it "handles single positive integer" do
      stack = PostInFix::Infix.new("10").to_stack
      expect(stack[0]).to eq(10)
      stack = PostInFix::Infix.new("+10").to_stack
      expect(stack[0]).to eq(10)
    end
    
    it "handles single positive float" do
      stack = PostInFix::Infix.new("10.03").to_stack
      expect(stack[0]).to eq(10.03)
      stack = PostInFix::Infix.new("+10.03").to_stack
      expect(stack[0]).to eq(10.03)
    end
    
    it "handles single negative integer" do
      stack = PostInFix::Infix.new("-10").to_stack
      expect(stack[0]).to eq(-10)
    end
    
    it "handles single negative float" do
      stack = PostInFix::Infix.new("-10.03").to_stack
      expect(stack[0]).to eq(-10.03)
    end
    
    it 'handles 1+2' do
      stack = PostInFix::Infix.new("1+2").to_stack
      expect(stack[0]).to eq(1)
      expect(stack[1]).to eq(2)
      expect(stack[2]).to be_a(PostInFix::Operator)
      expect(stack[2].sign).to eq("+")
    end

    it 'handles (1+2)*3' do
      stack = PostInFix::Infix.new("(1+2)*3").to_stack
      expect(stack[0]).to eq(1)
      expect(stack[1]).to eq(2)
      expect(stack[2]).to be_a(PostInFix::Operator)
      expect(stack[2].sign).to eq("+")
      expect(stack[3]).to eq(3)
      expect(stack[4]).to be_a(PostInFix::Operator)
      expect(stack[4].sign).to eq("*")
    end

    it 'handles ((1+2)*3)/(4+5)' do
      stack = PostInFix::Infix.new("((1+2)*3)/(4+5)").to_stack
      expect(stack[0]).to eq(1)
      expect(stack[1]).to eq(2)
      expect(stack[2]).to be_a(PostInFix::Operator)
      expect(stack[2].sign).to eq("+")
      expect(stack[3]).to eq(3)
      expect(stack[4]).to be_a(PostInFix::Operator)
      expect(stack[4].sign).to eq("*")
      expect(stack[5]).to eq(4)
      expect(stack[6]).to eq(5)
      expect(stack[7]).to be_a(PostInFix::Operator)
      expect(stack[7].sign).to eq("+")
      expect(stack[8]).to be_a(PostInFix::Operator)
      expect(stack[8].sign).to eq("/")
    end

    it 'handles variables: (foo+bar)*(3-baz)' do
      stack = PostInFix::Infix.new("(foo+bar)*(3-baz)").to_stack
      expect(stack[0]).to eq("foo")
      expect(stack[1]).to eq("bar")
      expect(stack[2]).to be_a(PostInFix::Operator)
      expect(stack[2].sign).to eq("+")
      expect(stack[3]).to eq(3)
      expect(stack[4]).to eq("baz")
      expect(stack[5]).to be_a(PostInFix::Operator)
      expect(stack[5].sign).to eq("-")
      expect(stack[6]).to be_a(PostInFix::Operator)
      expect(stack[6].sign).to eq("*")
    end
  end

  context "Postfix" do
    context "Solr" do
      it "compatible expression from: 1+2" do
        solr = PostInFix::Infix.new("1+2").to_postfix.to_solr
        expect(solr).to eq("add(1,2)")
      end

      it "compatible expression from: (foo*(3+bar))/(baz-9)" do
        solr = PostInFix::Infix.new("(foo*(3+bar))/(baz-9)").to_postfix.to_solr
        expect(solr).to eq("div(product(foo,add(3,bar)),sub(baz,9))")
      end
    end
  end
end
