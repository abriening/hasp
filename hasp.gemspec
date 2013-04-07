require File.expand_path("../lib/hasp", __FILE__)

Gem::Specification.new do |s|
  s.name                      = "hasp"
  s.version                   = Hasp::VERSION
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = ["Andrew Briening"]
  s.email                     = ["abriening+hasp@gmail.com"]
  s.homepage                  = "http://github.com/abriening/hasp"
  s.summary                   = "A user authorization tool."
  s.description               = "A lightweight user authorization tool for Rails."
  s.required_ruby_version     = ">= 1.9.3"
  s.required_rubygems_version = ">= 1.8.23"
  s.files                     = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path              = 'lib'
end
