class LogsController < ApplicationController
  before_filter :init_network_and_channel

  def index
    @logs   = Log.order(Log.arel_table[:created_at].desc).where(:network => @network).where(:channel => @channel)
    @logs   = @logs.search_text(params[:search]) if params[:search]
    respond_to do |format|
      format.html { @logs = @logs.page(params[:page]) }
      format.rss do
        @logs = @logs.where(Log.arel_table[:created_at].gt(100.week.ago))
        render :layout => false
      end
    end
  end

  def create
    @log = Log.new(params.require(:log).permit(:sender, :line))
    @log.network = params[:network]
    @log.channel = params[:channel]
    @log.save
    render :xml => @log
  end

  def random
    @log = Log.where(:network => @network).
               where(:channel => @channel).
               random
    render :text => @log.line
  end

  def search
    logs = Log.where(:network => @network).
               where(:channel => @channel).
               search_text(params[:term])
    count = logs.count
    @log = logs.random if count > 0
    render :text => @log ? "#{@log.line} (#{count} resultats)" : "No result"
  end

  def previous
    @log = Log.where(:network => @network).
               where(:channel => @channel).
               previous(params[:offset].to_i)
    render :text => "#{@log.line} (ajoute par #{@log.sender || 'unknown'} le #{@log.created_at})"
  end

private
  def init_network_and_channel
    @network = params[:network]
    @channel = params[:channel]
  end
end
