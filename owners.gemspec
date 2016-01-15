require File.expand_path("../lib/owners/version", __FILE__)

Gem::Specification.new do |s|
  s.author                = "Sean Huber"
  s.email                 = "github@shuber.io"
  s.extra_rdoc_files      = %w(LICENSE)
  s.files                 = `git ls-files`.split("\n")
  s.homepage              = "https://github.com/shuber/owners"
  s.license               = "MIT"
  s.name                  = "owners"
  s.rdoc_options          = %w(--charset=UTF-8 --inline-source --line-numbers --main README.md)
  s.require_paths         = %w(lib)
  s.required_ruby_version = ">= 2.0.0"
  s.summary               = "Take ownership of your code"
  s.test_files            = `git ls-files -- spec/*`.split("\n")
  s.version               = Owners::VERSION

  s.executables << "owners"

  s.add_development_dependency "rspec"
  s.add_dependency "thor"
end
