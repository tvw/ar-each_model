$: << File.expand_path("../lib",__FILE__) unless $:.include?(File.expand_path("../lib",__FILE__))
require 'active_record'
require 'yaml'
require 'logger'

require 'active_record/relation/each_model'
require 'model/testdata'

task :environment do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('db/config/database.yml')))
  ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))
end

task :default => :demo

desc "Run the demo code"
task :demo => :environment do
  Testdata.where("id > 2").order("id desc").limit(10).each_model do |td|
    puts td.inspect
  end
end

namespace :db do
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

  desc "Removes the database and the logfile"
  task :clean do
    rm_rf 'log/database.log'
    rm_rf 'db/testdb.sqlite.db'
  end

  desc "Recreates the database"
  task :reset => [:clean, :migrate]
end
