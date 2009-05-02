class AddFeedItemTwitterFields < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :from_user, :string
    add_column :feed_items, :from_user_id, :integer
  end

  def self.down
    remove_column :feed_items, :from_user_id
    remove_column :feed_items, :from_user
  end
end
