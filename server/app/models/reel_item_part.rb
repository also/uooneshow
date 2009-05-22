class ReelItemPart < ActiveRecord::Base
  belongs_to :reel_item
  default_scope :order => 'created_at DESC'
end
