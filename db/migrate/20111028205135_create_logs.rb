class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :network
      t.string :channel
      t.text   :line
      t.string :sender

      t.timestamps
    end
  end
end
