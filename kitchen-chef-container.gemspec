# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'kitchen/driver/version'

Gem::Specification.new do |s|
  s.name          = "kitchen-chef-container"
  s.version       = Kitchen::ChefContainer::VERSION
  s.authors       = ["Scott Hain"]
  s.email         = ["shain@getchef.com"]
  s.homepage      = "https://github.com/scotthain/kitchen-chef-container"
  s.summary       = "test-kitchen provisioner for chef-container"
  s.description   = "test-kitchen provisioner for chef-container"
  candidates = Dir.glob("{lib}/**/*") +  ['README.md', 'kitchen-chef-container.gemspec']

#  s.add_dependency "kitchen-docker"

  s.files = candidates.sort
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'
end
