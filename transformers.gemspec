# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "transformers/version"

Gem::Specification.new do |s|
  s.name        = "transformers"
  s.version     = Transformers::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Deepak N"]
  s.email       = ["endeep123@gmail.com"]
  s.homepage    = "https://github.com/endeepak/transformers"
  s.summary     = %q{DSL to transform a hash}
  s.description = %q{An extension to hash to allow various transformations using simple DSL}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_runtime_dependency("activesupport", "~> 3.0.0")
  s.add_development_dependency("rails", "~> 3.0.0")
  s.add_development_dependency("rspec", "~> 2.5.0")
  s.add_development_dependency("mocha", "~> 0.9.10")
end
