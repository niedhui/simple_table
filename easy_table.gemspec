# -*- encoding: utf-8 -*-
require File.expand_path('../lib/easy_table/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["niedhui"]
  gem.email         = ["dianhui.nie@gmail.com"]
  gem.description   = %q{Easy way to create table}
  gem.summary       = %q{Easy way to create table}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "easy_table"
  gem.require_paths = ["lib"]
  gem.version       = EasyTable::VERSION
end
