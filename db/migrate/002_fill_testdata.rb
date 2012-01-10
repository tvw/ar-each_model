require 'model/testdata'

class FillTestdata < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      50_000.times do |n|
        puts "    ... #{n} records added (#{Time.now}) ..." if n % 10000 == 0 and n > 0
        Testdata.add_random_data(n)
      end
    end
  end
  
  def self.down
    Testdata.all.delete
  end
end
