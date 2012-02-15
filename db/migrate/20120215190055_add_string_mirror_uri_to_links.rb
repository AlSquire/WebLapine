class AddStringMirrorUriToLinks < ActiveRecord::Migration
  def change
    add_column :links, :mirror_uri, :string
  end
end
