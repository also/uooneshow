require 'open-uri'

class FeedItem < ActiveRecord::Base
  belongs_to :snapshot

  named_scope :since_id, lambda { |id| {:conditions => ['id > ?', id]} }
  named_scope :from, lambda { |source| {:conditions => {:source => source.to_s}} }

  def self.update_twitter
    max_twitter_id = FeedItem.from(:twitter).maximum(:remote_id) || 0
    response_string = open("http://search.twitter.com/search.json?tag=uooneshow&rpp=100&since_id=#{max_twitter_id}").read
    response = ActiveSupport::JSON.decode(response_string)
    response['results'].collect do |tweet|
      FeedItem.create(
        :source => 'twitter',
        :remote_id => tweet['id'],
        :text => tweet['text'],
        :profile_image_url => tweet['profile_image_url'],
        :from_user => tweet['from_user'],
        :from_user_id => tweet['from_user_id'],
        :created_at => tweet['created_at']
      )
    end
  end

  def self.update_flickr
    flickr = Flickr.new('config/flickr.yml')
    photos = flickr.photos.search(:tags => 'uooneshow')
    p photos.first
    photos.collect do |photo|
      FeedItem.create(
        :source => 'flickr',
        :remote_id => photo.id,
        :text => photo.title,
        :medium_image_url => photo.url,
        :from_user => photo.owner_name,
        :from_user_id => photo.owner
      )
    end
  end

  def image_url
    if snapshot
      snapshot.path
    elsif profile_image_url
      profile_image_url
    elsif medium_image_url
      medium_image_url
    end
  end

  def to_json(*args)
    super(:methods => [:image_url])
  end
end
