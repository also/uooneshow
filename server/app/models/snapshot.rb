class Snapshot < ActiveRecord::Base
  attr_writer :data

  def after_create
    File.open("#{RAILS_ROOT}/public/#{path}", 'w') { |f| f.write(@data) } if @data
  end

  def path
    "/snapshots/#{id}.png"
  end

  def image_url
    url || path
  end
end
