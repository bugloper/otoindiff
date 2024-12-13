# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'

Minitest::TestTask.create

namespace :benchmark do
  desc 'Run benchmarks'
  task :run do
    puts 'Running benchmarks...'
    system('ruby benchmarks/benchmark.rb')
  end
end

task default: :test
