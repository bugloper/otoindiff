# frozen_string_literal: true

require 'test_helper'

class OtoindiffTest < Minitest::Test
  def setup
    @hash = { foo: 'bar', 'baz' => 'qux', nested: { key: 'value' } }
  end

  def test_access_with_symbol_key
    assert_equal 'bar', @hash[:foo]
  end

  def test_access_with_string_key
    assert_equal 'bar', @hash['foo']
  end

  def test_access_with_missing_key
    assert_nil @hash[:missing]
    assert_nil @hash['missing']
  end

  def test_nested_access_with_dig_symbol_key
    assert_equal 'value', @hash.dig(:nested, :key)
  end

  def test_nested_access_with_dig_string_key
    assert_equal 'value', @hash.dig('nested', 'key')
  end

  def test_fetch_with_symbol_key
    assert_equal 'bar', @hash.fetch(:foo)
  end

  def test_fetch_with_string_key
    assert_equal 'bar', @hash.fetch('foo')
  end

  def test_fetch_with_default_value
    assert_equal 'default', @hash.fetch(:missing, 'default')
  end

  def test_fetch_with_block
    result = @hash.fetch(:missing) { 'computed default' }
    assert_equal 'computed default', result
  end

  def test_dig_with_missing_keys
    assert_nil @hash.dig(:nested, :missing)
    assert_nil @hash.dig('nested', 'missing')
  end
end
