# frozen_string_literal: true

require_relative 'otoindiff/version'

# Extends Ruby's Hash class with more flexible key access methods
#
# This extension provides enhanced hash key lookup capabilities:
# - Allows interchangeable use of string and symbol keys
# - Provides more forgiving key access methods
# - Maintains original Hash behavior while adding convenience
#
# @example Flexible key access
#   hash = { foo: 'bar', 'baz' => 'qux' }
#   hash[:foo]    # => 'bar'
#   hash['foo']   # => 'bar'
#   hash.dig('baz', :key)  # Nested key access with mixed key types
#
# @note This extension is designed to be non-intrusive and backwards compatible
class Hash
  alias original_brackets []
  alias original_dig dig
  alias original_fetch fetch

  # Retrieve a hash value with flexible key type conversion
  #
  # @param key [Object] The key to retrieve
  # @return [Object, nil] The value associated with the key, or the hash's default if not found
  def [](key)
    original_brackets(otoindiff_key(key))
  end

  # Dig into a nested hash with flexible key type conversion
  #
  # @param key [Object] The first key to retrieve
  # @param rest [Array<Object>] Remaining path of keys, passed on to the nested object's #dig
  # @return [Object, nil] The nested value, or nil if path is invalid
  def dig(key, *rest)
    value = self[key]
    rest.empty? || value.nil? ? value : value.dig(*rest)
  end

  # Fetch a hash value with flexible key type conversion and error handling
  #
  # @param key [Object] The key to retrieve
  # @param args [Array] Optional default value or block
  # @return [Object] The value associated with the key
  # @raise [KeyError] If key is not found and no default is provided
  def fetch(key, *args, &block)
    original_fetch(otoindiff_key(key), *args, &block)
  end

  private

  # Resolve a String/Symbol key to whichever form is actually stored.
  # Falls back to the caller's key so defaults and default procs receive it unchanged.
  def otoindiff_key(key)
    return key if key?(key)

    alt = case key
          when String then key.to_sym
          when Symbol then key.to_s
          end
    alt && key?(alt) ? alt : key
  end
end
