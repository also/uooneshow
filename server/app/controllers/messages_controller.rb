class MessagesController < ApplicationController
  def index
    scope = Message
    scope = scope.since_id(params[:since_id]) if params[:since_id]

    @messages = scope.all :order => 'created_at DESC'
    respond_to do |format|
      format.html
      format.json { render :json => {:messages => @messages, :max_id => Message.maximum(:id)} }
    end
  end

  def new
  end

  def create
    if @message = Message.create(params[:message])
      redirect_to new_message_url
    else
      render :text => 'nope!'
    end
  end
end
