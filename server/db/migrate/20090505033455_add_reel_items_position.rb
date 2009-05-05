class AddReelItemsPosition < ActiveRecord::Migration
  def self.up
    add_column :reel_items, :position, :integer
  end

  def self.down
    add_column :reel_items, :position
  end
end
