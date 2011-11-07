$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "krembo_i18nizer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "krembo_i18nizer"
  s.version     = KremboI18nizer::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of KremboI18nizer."
  s.description = "TODO: Description of KremboI18nizer."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.1"

  s.add_development_dependency "sqlite3"
end
