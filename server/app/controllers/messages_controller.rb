class MessagesController < ApplicationController
  def index
    @messages = Message.all :order => 'created_at DESC'
    respond_to do |format|
      format.html
      format.json { render :json => @messages, :include => :snapshot }
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
