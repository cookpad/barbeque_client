# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'barbeque_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'barbeque_client'
  spec.version       = BarbequeClient::VERSION
  spec.authors       = ['Takashi Kokubun']
  spec.email         = ['takashi-kokubun@cookpad.com']

  spec.summary       = %q{Barbeque client for Ruby}
  spec.description   = %q{Barbeque client for Ruby}
  spec.homepage      = 'https://github.com/cookpad/barbeque_client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'garage_client'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rails', '~> 6.1.4'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec-rails'
end
