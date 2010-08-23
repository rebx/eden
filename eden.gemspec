EDEN_GEMSPEC = Gem::Specification.new do |s|
  s.name = 'eden'
  s.version = '0.1.1'
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = false
  s.summary = "A source-code formatter for Ruby"
  s.author = "Jason Langenauer"
  s.email = "jason@jasonlangenauer.com"
  s.homepage = "http://github.com/jasonl/eden"
  s.required_ruby_version = ">= 1.8.6"
  s.files = %w(LICENSE CHANGELOG README.md Rakefile) + Dir["{bin,lib,test}/**/*"]
  s.require_path = "lib"
  s.bindir = 'bin'
  s.executables << 'eden'
  s.description = <<-DESC
A source-code formatter for Ruby, based on a robust lexical analyser, and a modular
format for easy configuration and expansion.
DESC
end