class AddIndexesToLinks < ActiveRecord::Migration
  def self.up
    add_index :links, [:network, :channel]
  end

  def self.down
    remove_index :links, [:network, :channel]
  end
end
