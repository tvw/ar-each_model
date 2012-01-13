$: << File.expand_path("../lib",__FILE__) unless $:.include?(File.expand_path("../lib",__FILE__))
require 'active_record'
require 'yaml'
require 'logger'
require 'benchmark'

require 'model/testdata'

task :environment do
  DB_ENV = ENV.has_key?('DB_ENV') ? ENV['DB_ENV'] : "sqlite3"
  LOGFILE = "log/database-#{DB_ENV}.log"

  puts "Running with database driver #{DB_ENV} ..."
end

task :connect => :environment do
  if DB_ENV == "sqlite3"
    require 'active_record/relation/sqlite3/each_model'
  elsif DB_ENV == "mysql"
    require 'active_record/relation/mysql/each_model'
  else
    raise "driver not supported"
  end

  dbconf = YAML::load(File.open('db/config/database.yml'))
  ActiveRecord::Base.establish_connection(dbconf[DB_ENV])
  ActiveRecord::Base.logger = Logger.new(File.open(LOGFILE, 'a'))
end

task :default => :demo

desc "Run the demo code"
task :demo => :connect do
  Testdata.where("id > 2").order("id desc").limit(10).each_model do |td|
    puts td.inspect
  end
end

namespace :bm do
  desc "benchmark each"
  task :each => :connect do
    puts "waiting 10s ..."
    Kernel.sleep(10)
    puts "START"
    puts Benchmark.measure {
      Testdata.where("id > 0").order("id desc").each do |td|
      end
    }
  end

  desc "benchmark find_each"
  task :find_each => :connect do
    puts "waiting 10s ..."
    Kernel.sleep(10)
    puts "START"
    puts Benchmark.measure {
      Testdata.where("id > 0").order("id desc").find_each(:batch_size => 100000) do |td|
      end
    }
  end

  desc "benchmark each_model"
  task :each_model => :connect do
    puts "waiting 10s ..."
    Kernel.sleep(10)
    puts "START"
    puts Benchmark.measure {
      Testdata.where("id > 0").order("id desc").each_model do |td|
      end
    }
  end
end

namespace :db do
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migrate => :connect do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

  desc "Removes the database and the logfile"
  task :clean => :connect do
    if DB_ENV == "sqlite3"
      rm_rf 'db/testdb.sqlite.db'
    else
      ActiveRecord::Migrator.migrate('db/migrate', 2)
    end
    ActiveRecord::Base.connection.close
    rm_rf LOGFILE
  end

  desc "Recreates the database"
  task :reset => [:clean, :migrate]
end
