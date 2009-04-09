class Snapshot < ActiveRecord::Base
  def path
    "/snapshots/#{id}.png"
  end
end
