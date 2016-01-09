# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord/opsworks/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-opsworks"
  spec.version       = Activerecord::Opsworks::VERSION
  spec.authors       = ["Gaurish Sharma"]
  spec.email         = ["contact@gaurishsharma.com"]

  spec.summary       = %q{Make Database migrations concurrent-safe formulti-instance clusters such as Opsworks in Rails 4}
  spec.description   = %q{Running multiple migrations simultaneously can cause race conditions.
    This is especially a problem with Rails deployments to multi-instance clusters such as Opsworks.
    This code is backported from Rails 5, to be used in Rails 4. Supports MySql & Postgres}
  spec.homepage      = "https://github.com/gaurish/activerecord-opsworks"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "> 4", "< 5"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
