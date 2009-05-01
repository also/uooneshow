class FeedItemsController < ApplicationController
  def index
    scope = FeedItem
    scope = scope.since_id(params[:since_id]) if params[:since_id]

    @feed_items = scope.all :order => 'created_at DESC', :limit => 15
    @feed_items.reverse
    respond_to do |format|
      format.html
      format.json { render :json => {:feed_items => @feed_items, :max_id => FeedItem.maximum(:id)} }
    end
  end

  def new
  end

  def create
    attributes = params[:feed_item]
    attributes[:source] = 'snapshot'
    if @feed_item = FeedItem.create(attributes)
      Display.send_message('display-feed new_message ' + @feed_item.to_json)
      redirect_to new_feed_item_url
    else
      render :text => 'nope!'
    end
  end
end