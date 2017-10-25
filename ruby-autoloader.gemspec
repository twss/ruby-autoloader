Gem::Specification.new do |s|
  s.name = "ruby-autoloader"
  s.version = "0.1.0"
  s.date = "2017-10-07"
  s.summary = "A ruby autoloader to load and namespace in a rails-like manner."
  s.authors = ["Terry Wilson"]
  s.email = "terry.wilson@twss.co.uk"
  s.files = ["lib/autoloader.rb"]
  s.license = "MIT"

  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "where_is"
end
