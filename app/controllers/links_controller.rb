class LinksController < ApplicationController
  def index
    @network = params[:network]
    @channel = params[:channel]
    @links   = Link.order('links.created_at DESC').find_all_by_network_and_channel(@network, @channel)
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def create
    @link = Link.new(params[:link])
    @link.network = params[:network]
    @link.channel = params[:channel]
    @link.save
    render :xml => @link
  end
end
