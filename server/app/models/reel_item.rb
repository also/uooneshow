class ReelItem < ActiveRecord::Base
  has_many :parts, :class_name => 'ReelItemPart'
end
