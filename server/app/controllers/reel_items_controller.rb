class ReelItemsController < ApplicationController
  def index
    @reel_items = ReelItem.all :order => 'position ASC, created_at DESC'

    respond_to do |format|
      format.json { render :json => {:reel_items => @reel_items} }
    end
  end
end
