class CreateReelItems < ActiveRecord::Migration
  def self.up
    create_table :reel_items do |t|
      t.string :slug
      t.string :title
      t.string :credit
      t.string :url
      t.string :image_url

      t.timestamps
    end
  end

  def self.down
    drop_table :reel_items
  end
end
