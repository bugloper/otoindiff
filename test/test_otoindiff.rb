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

  def test_default_proc_receives_original_key
    hash = Hash.new { |h, k| h[k] = [] }
    hash[:a] << 1
    assert_equal({ a: [1] }, hash)
  end

  def test_access_with_falsy_value
    assert_equal false, { 'x' => false }[:x]
    assert_equal false, { x: false }['x']
  end

  def test_fetch_with_default_finds_other_key_type
    assert_equal 'bar', @hash.fetch('foo', 'default')
    assert_equal 'qux', @hash.fetch(:baz, 'default')
  end

  def test_fetch_with_block_finds_other_key_type
    assert_equal('bar', @hash.fetch('foo') { 'computed default' })
  end

  def test_fetch_block_receives_original_key
    assert_equal('missing', @hash.fetch('missing') { |k| k })
  end

  def test_fetch_missing_key_raises
    assert_raises(KeyError) { @hash.fetch(:missing) }
  end

  def test_dig_into_array
    assert_equal 20, { a: [10, 20] }.dig('a', 1)
  end

  def test_dig_through_non_diggable_value_raises_type_error
    error = assert_raises(TypeError) { { a: 1 }.dig('a', :x) }
    assert_equal 'Integer does not have #dig method', error.message
  end

  def test_i18n_translations
    require 'i18n'
    backend = I18n::Backend::Simple.new
    backend.store_translations(:en, greeting: 'Hello %{name}', nested: { a: 'A' })

    assert_equal 'Hello Bob', backend.translate(:en, :greeting, name: 'Bob')
    assert_equal 'A', backend.translate(:en, 'nested.a')
  end
end

class OtoindiffDisabledTest < Minitest::Test
  using Otoindiff::Disabled

  def setup
    @hash = { foo: 'bar', 'baz' => 'qux', nested: { key: 'value', list: [{ item: 1 }] } }
  end

  def test_brackets_are_strict
    assert_equal 'bar', @hash[:foo]
    assert_nil @hash['foo']
    assert_nil @hash[:baz]
  end

  def test_fetch_is_strict
    assert_equal 'bar', @hash.fetch(:foo)
    assert_raises(KeyError) { @hash.fetch('foo') }
    assert_equal('default', @hash.fetch('foo', 'default'))
  end

  def test_dig_is_strict_at_every_level
    assert_equal 'value', @hash.dig(:nested, :key)
    assert_nil @hash.dig('nested', :key)
    assert_nil @hash.dig(:nested, 'key')
    assert_equal 1, @hash.dig(:nested, :list, 0, :item)
    assert_nil @hash.dig(:nested, :list, 0, 'item')
  end

  def test_dig_through_non_diggable_value_raises_type_error
    error = assert_raises(TypeError) { @hash.dig(:foo, :x) }
    assert_equal 'String does not have #dig method', error.message
  end
end

class OtoindiffOutsideDisabledTest < Minitest::Test
  def test_other_classes_remain_indifferent
    hash = { foo: 'bar' }
    assert_equal 'bar', hash['foo']
    assert_equal 'bar', hash.fetch('foo')
    assert_equal 'bar', hash.dig('foo')
  end
end

