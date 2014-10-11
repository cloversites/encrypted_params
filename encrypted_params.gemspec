# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'encrypted_params/version'

Gem::Specification.new do |spec|
  spec.name          = "encrypted_params"
  spec.version       = EncryptedParams::VERSION
  spec.authors       = ["CloverSites Inc."]
  spec.email         = ["support@cloversites.com"]
  spec.summary       = "Provides a simple method to send and receive encrypted data."
  spec.description   = ""
  spec.homepage      = "https://github.com/cloversites/encrypted_params"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  
  sepc.add_runtime_dependency "symmetric-encryption", "~> 3.6"
end
