class AddFeedItemFlickrFields < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :medium_image_url, :string
    change_column :feed_items, :from_user_id, :string
  end

  def self.down
    FeedItem.from(:flickr).destroy_all
    change_column :feed_items, :from_user_id, :integer
    remove_column :feed_items, :medium_image_url
  end
end
