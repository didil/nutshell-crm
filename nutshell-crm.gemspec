# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nutshell-crm/version"

Gem::Specification.new do |s|
  s.name        = "nutshell-crm"
  s.version     = NutshellCrm::VERSION
  s.authors     = ["Michael Shafrir"]
  s.email       = ["mshafrir@gmail.com"]
  s.homepage    = "https://github.com/mshafrir/nutshell-crm"
  s.summary     = "A Ruby wrapper for Nutshell CRM's API"
  s.description = "Description"

  s.add_development_dependency 'rake'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'json' , ">= 1.8.0"
  s.add_development_dependency 'httparty'
  s.add_development_dependency 'rspec'

  s.add_dependency 'json'
  s.add_dependency 'httparty'

  s.rubyforge_project = "nutshell-crm"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
