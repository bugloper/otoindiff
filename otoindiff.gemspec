# frozen_string_literal: true

require_relative 'lib/otoindiff/version'

Gem::Specification.new do |spec|
  spec.version       = Otoindiff::VERSION
  spec.name          = 'otoindiff'
  spec.authors       = ['bugloper']
  spec.email         = ['bugloper@gmail.com']

  spec.summary       = 'Enhances Ruby hashes with default indifferent access.'
  spec.description   = 'The otoindiff gem modifies all Ruby Hash objects to support indifferent access by default, allowing seamless use of string or symbol keys interchangeably.'
  spec.homepage      = 'https://github.com/bugloper/otoindiff'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri']     = spec.homepage
  spec.metadata['source_code_uri']  = 'https://github.com/bugloper/otoindiff'
  spec.metadata['changelog_uri']    = 'https://github.com/bugloper/otoindiff/blob/main/CHANGELOG.md'

  # Specify files included in the gem
  spec.files = Dir.chdir(__dir__) do
    IO.popen(%w[git ls-files -z], err: IO::NULL).read.split("\x0").reject do |file|
      file.start_with?('test/', 'spec/', 'features/', '.git', 'Gemfile', 'appveyor') ||
        File.basename(file) == File.basename(__FILE__)
    end
  end
  spec.bindir         = 'exe'
  spec.executables    = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths  = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'false'
  # rubocop:enable Gemspec/RequireMFA
  # Runtime dependencies
  spec.add_runtime_dependency 'activesupport', '~> 8.0'
end
