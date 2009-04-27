class AddReelItemMediaType < ActiveRecord::Migration
  def self.up
    add_column :reel_items, :media_type, :string
    rename_column :reel_items, :image_url, :media_url

    ReelItem.reset_column_information
    ReelItem.update_all "media_type = 'image'"
  end

  def self.down
    rename_column :reel_items, :media_url, :image_url
    remove_column :reel_items, :media_type
  end
end
