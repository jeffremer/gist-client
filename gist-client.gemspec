# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gist-client/version"

Gem::Specification.new do |s|
  s.name        = "gist-client"
  s.version     = Gist::Client::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jeff Remer"]
  s.email       = ["jeff@threestarchina.com"]
  s.homepage    = "http://jeffremer.com"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "gist-client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files spec`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency "rspec", "~> 2.5.0"
  s.add_development_dependency "webmock", "~> 1.6.2"
  
  s.add_dependency "json", "~> 1.5.1"
  s.add_dependency "rest-client", "~> 1.4.2"
  s.add_dependency "mash", "~> 0.1.1"
end
