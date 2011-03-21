class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :network
      t.string :channel
      t.text :line

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
