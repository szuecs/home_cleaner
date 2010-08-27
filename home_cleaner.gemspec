# WARNING : RAKE AUTO-GENERATED FILE.  DO NOT MANUALLY EDIT!
# RUN : 'rake gem:update_gemspec'

Gem::Specification.new do |s|
  s.authors = ["Sandor Szuecs"]
  s.bindir = "bin"
  s.description = "home_cleaner deletes user directories on a Mac OS X computer when they are old enough and not blacklisted or not logged in. This can be useful for maintaining a pc lab."
  s.email = "sandor.szuecs@fu-berlin.de"
  s.executables = ["home_cleaner"]
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "README.rdoc"]
  s.files = ["CHANGELOG.rdoc",
 "LICENSE",
 "README.rdoc",
 "bin/home_cleaner",
 "config/home_cleaner.yml",
 "config/test.yml",
 "launchd/de.fuberlin.home_cleaner.plist",
 "lib/home_cleaner.rb",
 "test/test_home_cleaner.rb"]
  s.has_rdoc = true
  s.homepage = "http://github.com/szuecs/home_cleaner"
  s.loaded = false
  s.name = "home_cleaner"
  s.platform = "ruby"
  s.rdoc_options = ["--quiet", "--title", "HomeCleaner cleans the given home directory, besides blacklisted accounts and currently logged in users of your local disk.", "--opname", "index.html", "--main", "lib/home_cleaner.rb", "--line-numbers", "--inline-source"]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 1.8.6"
  s.required_rubygems_version = ">= 0"
  s.rubyforge_project = "home_cleaner"
  s.rubygems_version = "1.3.7"
  s.specification_version = 3
  s.summary = "HomeCleaner cleans the given home directory, besides blacklisted accounts and currently logged in users of your local disk."
  s.test_files = ["test/test_home_cleaner.rb"]
  s.version = "10.8.27.1"
end