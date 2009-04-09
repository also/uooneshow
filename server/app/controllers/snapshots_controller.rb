class SnapshotsController < ApplicationController
  def index
    @snapshots = Snapshot.all :order => 'created_at DESC'
  end

  def create
    @snapshot = Snapshot.create
    File.open("#{RAILS_ROOT}/public/#{@snapshot.path}", 'w') {|f| f.write(request.body.string) }
    render :nothing => true
  end
end
