require 'digest'
class Testdata < ActiveRecord::Base
  def self.add_random_data(n)
    t = Testdata.new
    t.name = Digest::SHA256.new.hexdigest(n.to_s + Time.new.to_s)
    t.save
  end
end
