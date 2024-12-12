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
