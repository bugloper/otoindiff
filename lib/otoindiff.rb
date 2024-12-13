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
  # @return [Object, nil] The value associated with the key, or nil if not found
  def [](key)
    return original_brackets(key) if key?(key)

    if key.is_a?(String) || key.is_a?(Symbol)
      original_brackets(key.to_s) || original_brackets(key.to_sym)
    else
      original_brackets(key)
    end
  end

  # Dig into a nested hash with flexible key type conversion
  #
  # @param keys [Array<Object>] Path of keys to traverse
  # @return [Object, nil] The nested value, or nil if path is invalid
  def dig(*keys)
    keys.reduce(self) do |current, key|
      break nil unless current.is_a?(Hash)

      if key.is_a?(String) || key.is_a?(Symbol)
        current.original_brackets(key) ||
          current.original_brackets(key.to_s) ||
          current.original_brackets(key.to_sym)
      else
        current.original_brackets(key)
      end
    end
  end

  # Fetch a hash value with flexible key type conversion and error handling
  #
  # @param key [Object] The key to retrieve
  # @param args [Array] Optional default value or block
  # @return [Object] The value associated with the key
  # @raise [KeyError] If key is not found and no default is provided
  def fetch(key, *args, &block)
    return original_fetch(key, *args, &block) if key?(key)

    if key.is_a?(String) || key.is_a?(Symbol)
      begin
        original_fetch(key.to_s, *args, &block)
      rescue KeyError
        original_fetch(key.to_sym, *args, &block)
      end
    else
      original_fetch(key, *args, &block)
    end
  end
end
