class RenameMessagesFeedItems < ActiveRecord::Migration
  def self.up
    rename_table :messages, :feed_items
  end

  def self.down
    rename_table :feed_items, :messages
  end
end
