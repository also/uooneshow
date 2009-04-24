require 'open-uri'

class Message < ActiveRecord::Base
  belongs_to :snapshot

  named_scope :since_id, lambda { |id| {:conditions => ['id > ?', id]} }
  named_scope :from, lambda { |source| {:conditions => {:source => source.to_s}} }

  def self.update_twitter
    max_twitter_id = Message.from(:twitter).maximum(:remote_id) || 0
    response_string = open("http://search.twitter.com/search.json?tag=oneshow&rpp=100&since_id=#{max_twitter_id}").read
    response = ActiveSupport::JSON.decode(response_string)
    response['results'].collect do |tweet|
      Message.create :source => 'twitter', :remote_id => tweet['id'], :text => tweet['text'], :profile_image_url => tweet['profile_image_url']
    end
  end
end
