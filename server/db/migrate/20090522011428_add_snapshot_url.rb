class AddSnapshotUrl < ActiveRecord::Migration
  def self.up
    add_column :snapshots, :url, :string
  end

  def self.down
    remove_column :snapshots, :url
  end
end
