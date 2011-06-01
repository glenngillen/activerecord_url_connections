# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "activerecord_url_connections/version"

Gem::Specification.new do |s|
  s.name        = "activerecord_url_connections"
  s.version     = ActiverecordURLConnections::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Glenn Gillen"]
  s.email       = ["glenn@rubypond.com"]
  s.homepage    = ""
  s.summary     = %q{Convert URLs into AR friendly hashes}
  s.description = %q{Allows database connections to be defined as URLS, then converted to hash for use in ActiveRecord}
  s.rubyforge_project = "activerecord_url_connections"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
