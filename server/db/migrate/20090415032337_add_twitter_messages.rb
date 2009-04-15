class AddTwitterMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :source, :string
    add_column :messages, :remote_id, :string
  end

  def self.down
    remove_column :messages, :remote_id
    remove_column :messages, :source
  end
end
