class Initialize < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :name, :string, :null=>false
    end
  end

  def self.down
    drop_table :events
  end
end
