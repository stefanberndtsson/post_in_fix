# PostInFix

Parse an expression in infix format using the Infix class, and obtain a stack based
notation from it (RPN). The stack output can also be converted into a Postfix object,
for further translation into other forms.

The only use so far for this has been to convert infix notated Solr boost expressions
into a form Solr can understand. Therefor to_solr() is the only output of the Postfix
class.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'post_in_fix'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install post_in_fix

## Usage

Stack from a simple expression:
```ruby
infix = PostInFix::Infix.new("1+2")
infix.to_stack  # => [1, 2, OP<+>]
```

```OP<+>``` here is an object of the class PostInFix::Operator

Stack from a slightly more complex expression:
```ruby
infix = PostInFix::Infix.new("(33.73+9.2)*7")
infix.to_stack  # => [33.73, 9.2, OP<+>, 7, OP<*>]
```

Stack from an expression where variables (non-values) are included:
```ruby
infix = PostInFix::Infix.new("foo/(3.2*(bar-baz))")
infix.to_stack  # => ["foo", 3.2, "bar", "baz", OP<->, OP<*>, OP</>]
```

Output a Solr compatible expression from that last expression:
```ruby
infix = PostInFix::Infix.new("foo/(3.2*(bar-baz))")
infix.to_postfix.to_solr  # => "div(foo,product(3.2,sub(bar,baz)))"
```

## Contributing

1. Fork it ( https://github.com/stefanberndtsson/post_in_fix/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
