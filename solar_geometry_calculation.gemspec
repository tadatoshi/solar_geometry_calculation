# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "solar_geometry_calculation/version"

Gem::Specification.new do |s|
  s.name        = "solar_geometry_calculation"
  s.version     = SolarGeometryCalculation::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tadatoshi Takahashi"]
  s.email       = ["tadatoshi@gmail.com"]
  s.homepage    = "https://github.com/tadatoshi/solar_geometry_calculation"
  s.summary     = %q{Performs calculation for solar geometry}
  s.description = %q{Mathematical part of obtaining solar geometry information}

  s.rubyforge_project = "solar_geometry_calculation"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'tzinfo'
  s.add_dependency 'activesupport', ">= 4.1.1"

  s.add_development_dependency "rspec"
end