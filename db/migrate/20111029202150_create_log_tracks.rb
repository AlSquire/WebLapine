class CreateLogTracks < ActiveRecord::Migration
  def change
    create_table :log_tracks do |t|
      t.references :log

      t.timestamps
    end
  end
end
