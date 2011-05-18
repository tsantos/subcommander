require 'rubygems'
require 'rake/gempackagetask'
require 'rake/clean'

GEM         = 'subcommander'
GEM_VERSION = '1.0.4'

spec = Gem::Specification.new do |s|
  s.author      = 'Tom Santos'
  s.email       = 'santos.tom@gmail.com'
  s.homepage    = "http://github.com/tsantos/subcommander"
  s.name        = GEM
  s.version     = GEM_VERSION

  s.summary     = "A library for cleanly handling subcommands (and options), like Git"
  s.description = s.summary
  s.has_rdoc    = false
  s.platform    = Gem::Platform::RUBY

  s.files = %w[
    README.markdown
    lib/subcommander.rb
  ]
end

Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true
end 

desc "Installs the gem locally"
task :install => :gem do |t|
  system "sudo gem install pkg/#{GEM}-#{GEM_VERSION}.gem"
end

desc "Pushes the gem to gemcutter"
task :push => :gem do |t|
  system "gem push pkg/#{GEM}-#{GEM_VERSION}.gem"
end

task :default => :gem

CLEAN.include 'pkg'
