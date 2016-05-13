# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logcompare/version'

Gem::Specification.new do |spec|
  spec.name          = "logcompare"
  spec.version       = Logcompare::VERSION
  spec.authors       = ["Mike Bell"]
  spec.email         = ["mike.bell@cenx.com"]

  spec.summary       = %q{Compare a set of log files looking for anomalies}
  spec.description   = %q{Compare a set of log files looking for anomolies}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.licenses      = "MIT"



  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
