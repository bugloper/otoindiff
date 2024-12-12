require_relative '../lib/otoindiff'
require 'benchmark'

sample_hash = {
  foo: 'bar',
  'baz' => 'qux',
  'nested' => { 'level1' => { 'level2' => 'value' } }
}

Benchmark.bm do |x|
  x.report('[] method (symbol key):') { 100_000.times { sample_hash[:foo] } }
  x.report('[] method (string key):') { 100_000.times { sample_hash['foo'] } }
end

Benchmark.bm do |x|
  x.report('dig method (nested):') { 100_000.times { sample_hash.dig('nested', 'level1', 'level2') } }
  x.report('dig method (non-nested):') { 100_000.times { sample_hash.dig(:foo) } }
end

Benchmark.bm do |x|
  x.report('fetch method (symbol key):') { 100_000.times { sample_hash.fetch(:foo) } }
  x.report('fetch method (string key):') { 100_000.times { sample_hash.fetch('foo') } }
end
