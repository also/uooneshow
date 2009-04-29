class FeedItemsController < ApplicationController
  def index
    scope = FeedItem
    scope = scope.since_id(params[:since_id]) if params[:since_id]

    @feed_items = scope.all :order => 'created_at DESC', :limit => 15
    respond_to do |format|
      format.html
      format.json { render :json => {:feed_items => @feed_items, :max_id => FeedItem.maximum(:id)} }
    end
  end

  def new
  end

  def create
    if @feed_item = FeedItem.create(params[:feed_item])
      redirect_to new_feed_item_url
    else
      render :text => 'nope!'
    end
  end
end
