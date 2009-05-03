class AddFeedItemsHidden < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :hidden, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :feed_items, :hidden
  end
end
