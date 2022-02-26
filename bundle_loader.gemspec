Gem::Specification.new do |s|
    s.name        = 'bundle_loader'
    s.version     = '0.1.0'
    s.summary     = "Gem to load json files into database using rails active_record"
    s.description = "Use this gem to load json files into database using rails active_record"
    s.authors     = ["Dani Vela"]
    s.email       = 'veladan@me.com'
    s.files       = ["lib/bundle_loader.rb"]
    s.homepage    =
      'https://github.com/madcato/bundle_loader'
    s.license       = 'MIT'

    s.add_runtime_dependency "activesupport", "~> 5"
    s.add_runtime_dependency "json", "~> 2.6"

    s.add_development_dependency "minitest", "~> 5"
    s.add_development_dependency "rake", "~> 12.0"
    s.add_development_dependency "bundler", "~> 2.1.0"
  end