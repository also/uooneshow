class ReelItem < ActiveRecord::Base
  has_many :parts, :class_name => 'ReelItemPart'

  def to_json(options)
    # TODO add to existing options
    super(:include => {:parts => {:only => [:id, :media_type, :media_url, :position]}})
  end
end
