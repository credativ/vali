# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

Gem::Specification.new do |spec|
  spec.name    = 'fluent-plugin-plutono-vali'
  spec.version = '1.2.16'

  spec.summary       = 'Output plugin to ship logs to a Plutono Vali server'
  spec.description   = 'Output plugin to ship logs to a Plutono Vali server'
  spec.homepage      = 'https://github.com/credativ/vali/'
  spec.license       = 'Apache-2.0'

  # test_files, files  = `git ls-files -z`.split("\x0").partition do |f|
  #   f.match(%r{^(test|spec|features)/})
  # end
  spec.files         = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md]
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # spec.files         = files
  # spec.executables   = files.grep(%r{^bin/}) { |f| File.basename(f) }
  # spec.test_files    = test_files
  # spec.require_paths = ['lib']

  spec.add_dependency 'fluentd', ['>=1.9.3', '< 2']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'test-unit'
end
