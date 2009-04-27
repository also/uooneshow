class ReelItemsController < ApplicationController
  def index
    @reel_items = ReelItem.all :order => 'created_at ASC'

    respond_to do |format|
      format.json { render :json => {:reel_items => @reel_items} }
    end
  end
end
