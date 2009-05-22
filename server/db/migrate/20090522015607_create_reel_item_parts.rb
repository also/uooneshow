class CreateReelItemParts < ActiveRecord::Migration
  def self.up
    create_table :reel_item_parts do |t|
      t.integer :reel_item_id, :null => false
      t.string :media_url, :null => false
      t.string :media_type, :null => false
      t.integer :position, :null => false

      t.timestamps
    end

    add_index :reel_item_parts, :reel_item_id

    ReelItemPart.reset_column_information
    ReelItem.all.each do |i|
      p = ReelItemPart.new :reel_item => i, :media_url => i.media_url, :media_type => i.media_type, :position => 1
      p.save!
    end

    remove_column :reel_items, :media_url
    remove_column :reel_items, :media_type
  end

  def self.down
    add_column :reel_items, :media_url, :string
    add_column :reel_items, :media_type, :string
    ReelItem.reset_column_information
    ReelItem.all.each do |i|
      p = i.parts.first
      i.update_attributes! :media_url => p.media_url, :media_type => p.media_type
    end
    drop_table :reel_item_parts
  end
end
