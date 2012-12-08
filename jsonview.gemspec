# -*- encoding: utf-8 -*-
require File.expand_path('../lib/jsonview/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Preston Guillory"]
  gem.email         = ["pguillory@gmail.com"]
  gem.description   = %q{JSONView for Rack}
  gem.summary       = %q{Rack middleware to convert JSON responses into attractive HTML representations. Mimics the JSONView browser plugin.}
  gem.homepage      = "https://github.com/pguillory/jsonview"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "jsonview"
  gem.require_paths = ["lib"]
  gem.version       = Jsonview::VERSION
end
