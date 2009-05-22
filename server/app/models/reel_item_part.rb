class ReelItemPart < ActiveRecord::Base
  belongs_to :reel_item
  default_scope :order => 'reel_item_parts.position ASC'
end
