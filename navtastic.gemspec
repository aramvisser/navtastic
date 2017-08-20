$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'navtastic/version'

Gem::Specification.new do |s|
  s.name     = 'navtastic'
  s.version  = Navtastic::VERSION
  s.summary  = "Define and render complex navigation menus"
  s.authors  = ["Aram Visser"]
  s.email    = "hello@aramvisser.com"
  s.homepage = "http://github.com/aramvisser/navtastic"
  s.license  = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'arbre'

  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'yard'
end
