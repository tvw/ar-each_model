class CreateTestdata < ActiveRecord::Migration
  def self.up
    create_table :testdata do |t|
      t.column :name, :string, :null => false
    end
  end
  
  def self.down
    drop_table :testdata
  end
end
