require "bundler"
Bundler.setup

gemspec = eval(File.read("hasp.gemspec"))

desc "build Hasp #{Hasp::VERSION} gemspec and install"
task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["hasp.gemspec"] do
  system "gem build hasp.gemspec"
  system "gem install hasp-#{Hasp::VERSION}.gem"
end

require 'rake/clean'
CLEAN.include "*.gem"

require 'rake/testtask'
task :test => :build
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end

task :default => :test
