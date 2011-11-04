class LogsController < ApplicationController
  before_filter :init_network_and_channel

  def index
    @logs   = Log.order(Log.arel_table[:created_at].desc).where(:network => @network).where(:channel => @channel)
    @logs   = @logs.search(params[:search]) if params[:search]
    respond_to do |format|
      format.html { @logs = @logs.page(params[:page]) }
      format.rss do
        @logs = @logs.where(Log.arel_table[:created_at].gt(100.week.ago))
        render :layout => false
      end
    end
  end

  def create
    @log = Log.new(params[:log])
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
    @log = Log.where(:network => @network).
               where(:channel => @channel).
               search(params[:term]).
               random
    render :text => @log.line
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
