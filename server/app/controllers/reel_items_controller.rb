class ReelItemsController < ApplicationController
  def index
    @reel_items = ReelItem.all :order => 'position ASC, created_at DESC'

    respond_to do |format|
      format.html
      format.json { render :json => {:reel_items => @reel_items} }
    end
  end

  def new
  end

  def create
    @reel_item = ReelItem.create(params[:reel_item])
    if @reel_item.save
      redirect_to reel_items_url
    else
      render :text => 'nope!'
    end
  end
end
