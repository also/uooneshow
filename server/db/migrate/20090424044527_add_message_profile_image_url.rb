class AddMessageProfileImageUrl < ActiveRecord::Migration
  def self.up
    add_column :messages, :profile_image_url, :string
  end

  def self.down
    remove_column :messages, :profile_image_url
  end
end
