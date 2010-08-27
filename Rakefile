require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "grantprix"
    
    gem.summary = "Adds GRANT SQL (for Postgres) syntax to your migrations"
    gem.description = "Adds GRANT SQL (for Postgres) syntax to your migrations"
    gem.homepage = "http://github.com/experteer/grantprix"
    
    gem.authors = ["Rudolf Schmidt"]
    
    gem.add_development_dependency 'rspec', ">=1.3.0"
  end
rescue LoadError
  "Jeweler, or one of its dependencies, is not available. Install it with `gem install jeweler`."
end


require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec


require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "grantprix #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
