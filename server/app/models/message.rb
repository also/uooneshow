class Message < ActiveRecord::Base
  belongs_to :snapshot
  named_scope :since_id, lambda { |id| {:conditions => ['id > ?', id]} }
end
