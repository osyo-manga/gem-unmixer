# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unmixer/version'

Gem::Specification.new do |spec|
  spec.name          = "unmixer"
  spec.version       = Unmixer::VERSION
  spec.authors       = ["manga_osyo"]
  spec.email         = ["manga.osyo@gmail.com"]

  spec.summary       = %q{Remove mixin modules.}
  spec.description   = %q{Remove mixin modules.}
  spec.homepage      = "https://github.com/osyo-manga/gem-unmixer"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.extensions    = %w[ext/unmixer/extconf.rb]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake-compiler"
end
