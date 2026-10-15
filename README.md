# Otoindiff

`otoindiff` is a Ruby gem that globally enhances the behavior of Ruby's `Hash` class to support **indifferent access** by default. With `otoindiff`, you can access hash keys using either symbols or strings interchangeably without any extra steps like calling `with_indifferent_access`.

## Features

- Seamlessly access hash keys as symbols or strings.
- Works with nested hashes and supports methods like `dig` and `fetch`.
- No need to manually call `with_indifferent_access` on hashes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'otoindiff'
```

## Usage

Requiring the gem enables indifferent access for every `Hash`:

```ruby
hash = { foo: 'bar', 'baz' => 'qux' }
hash['foo']        # => "bar"
hash[:baz]         # => "qux"
hash.fetch('foo')  # => "bar"
hash.dig('foo')    # => "bar"
```

### Opting a class out

To keep plain Hash behaviour in a single class, activate the
`Otoindiff::Disabled` refinement inside it. The rest of the code base stays
indifferent:

```ruby
class StrictParser
  using Otoindiff::Disabled

  def call(hash)
    hash['foo']  # => nil for { foo: 'bar' }; only the String key matches
  end
end
```

Refinements are lexical: they apply to `[]`, `fetch` and `dig` calls written
inside that class body, not to hashes the class hands to other code.

