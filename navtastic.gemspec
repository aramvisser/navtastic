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
  s.extra_rdoc_files = ['README.md']

  s.add_dependency 'arbre', '~> 1.1'

  s.add_development_dependency 'redcarpet', '~> 3.4'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rubocop', '~> 0.48'
  s.add_development_dependency 'rubocop-rspec', '~> 1.15'
  s.add_development_dependency 'yard', '~> 0.9'
end
