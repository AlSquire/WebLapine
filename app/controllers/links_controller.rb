class LinksController < ApplicationController
  def index
    @network = params[:network]
    @channel = params[:channel]
    @links   = Link.order('links.created_at DESC').where(:network => @network).where(:channel => @channel)
    respond_to do |format|
      format.html { @links = @links.page(params[:page]) }
      format.rss do
        @links = @links.where(["links.created_at > ?", 1.week.ago])
        render :layout => false
      end
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
