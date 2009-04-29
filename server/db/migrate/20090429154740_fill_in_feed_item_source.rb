class FillInFeedItemSource < ActiveRecord::Migration
  def self.up
    FeedItem.update_all("source = 'snapshot'", 'source IS NULL')
  end

  def self.down
    FeedItem.update_all('source = NULL', "source = 'snapshot'")
  end
end
