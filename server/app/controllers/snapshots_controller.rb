class SnapshotsController < ApplicationController
  def index
    @snapshots = Snapshot.all :order => 'created_at DESC'
  end

  def create
    @snapshot = Snapshot.create :data => request.body.string
    render :json => @snapshot
  end
end
