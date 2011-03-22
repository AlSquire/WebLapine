class AddSenderStringToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :sender, :string
  end

  def self.down
    remove_column :links, :sender
  end
end
