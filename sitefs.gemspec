# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sitefs/version'

Gem::Specification.new do |spec|
  spec.name          = "sitefs"
  spec.version       = Sitefs::VERSION
  spec.authors       = ["Tal Atlas"]
  spec.email         = ["me@tal.by"]

  spec.summary       = %q{A simple static site generator}
  spec.homepage      = "http://sitefs.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'html-pipeline', '~> 2.5'
  spec.add_dependency 'html-pipeline-rouge_filter', '~> 1.0'
  spec.add_dependency 'rinku', '~> 2.0'
  spec.add_dependency 'github-markdown', '~> 0.6'
  spec.add_dependency 'commonmarker', '~> 0.21'
  spec.add_dependency 'listen', '~> 3.1'
  spec.add_dependency 'sass', '~> 3.4'
  spec.add_dependency 'stamp', '~> 0.6'
  spec.add_dependency 'autoloaded', '~> 2'
  spec.add_dependency 'slop', '~> 4'
  spec.add_dependency 'diffy', '~> 3'
  spec.add_dependency 'mime-types', '~> 3'

  spec.add_dependency 'aws-sdk', '~> 2'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 13"
  spec.add_development_dependency "rspec", "~> 3.0"
end
