class FeedItemsController < ApplicationController
  skip_before_filter :require_admin, :only => [:index, :new, :create]

  def index
    scope = FeedItem.visible
    scope = scope.since_id(params[:since_id]) if params[:since_id]

    @feed_items = scope.all :order => 'created_at DESC, id DESC', :limit => 5
    @feed_items.reverse!
    respond_to do |format|
      format.html
      format.json { render :json => {:feed_items => @feed_items, :max_id => FeedItem.maximum(:id)} }
    end
  end

  def new
  end
  
  def hide
    feed_item = FeedItem.find(params[:id])
    feed_item.hide
    redirect_to feed_items_url
  end

  def create
    attributes = params[:feed_item]
    if attributes[:snapshot_id].empty?
      attributes[:source] ||= 'direct'
    else
      attributes[:source] ||= 'snapshot'
    end
    if @feed_item = FeedItem.create(attributes)
      Display.send_message('display-feed new_message ' + @feed_item.to_json)
      redirect_to new_feed_item_url
    else
      render :text => 'nope!'
    end
  end
end
