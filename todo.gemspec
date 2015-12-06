# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'todo/version'

Gem::Specification.new do |s|
  s.name          = 'todo.txt'
  s.version       = Todo::VERSION
  s.authors       = ['Sven Fuchs']
  s.email         = 'me@svenfuchs.com'
  s.homepage      = 'https://github.com/svenfuchs/todo.txt'
  s.summary       = 'My flavor of todo.txt'
  s.description   = "#{s.summary}."
  s.licenses      = ['MIT']

  s.files         = Dir['{lib/**/*,spec/**/*,[A-Z]*}']
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'
end
