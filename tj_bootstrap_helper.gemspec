$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tj_bootstrap_helper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tj_bootstrap_helper"
  s.version     = TJBootstrapHelper::VERSION
  s.authors     = ["Tony Jian"]
  s.email       = ["tonytonyjan@gmail.com"]
  #s.homepage    = "tonytnoyjan.github.com"
  s.summary     = "Tony Jian's Bootstrap helpers."
  s.description = "Tony Jian's Bootstrap helpers."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.6"

  s.add_development_dependency "sqlite3"
end
