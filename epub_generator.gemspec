# -*- encoding: utf-8 -*-
require File.expand_path('../lib/epub_generator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["banux"]
  gem.email         = ["banux@helheim.net"]
  gem.description   = %q{Generate an epub}
  gem.summary       = %q{generate an epub}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "epub_generator"
  gem.require_paths = ["lib"]
  gem.version       = EpubGenerator::VERSION
end
