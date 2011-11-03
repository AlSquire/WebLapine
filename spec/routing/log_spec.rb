require 'spec_helper'

describe "LogRoutes" do
  it do
    { :get => '/freenode/ruby/logs/' }.
    should route_to :controller => 'logs', :action => 'index',
                    :network => 'freenode', :channel => 'ruby'
  end

  it do
    { :get => '/freenode/ruby/logs.rss' }.
    should route_to :controller => 'logs', :action => 'index', :format => 'rss',
                    :network => 'freenode', :channel => 'ruby'
  end

  it do
    { :get => '/freenode/ruby/logs/random.txt' }.
    should route_to :controller => 'logs', :action => 'random', :format => 'txt',
                    :network => 'freenode', :channel => 'ruby'
  end

  it do
    { :get => '/freenode/ruby/logs/search.txt' }.
    should route_to :controller => 'logs', :action => 'search', :format => 'txt',
                    :network => 'freenode', :channel => 'ruby'
  end

  it do
    { :get => '/freenode/ruby/logs/previous.txt' }.
    should route_to :controller => 'logs', :action => 'previous', :format => 'txt',
                    :network => 'freenode', :channel => 'ruby'
  end

  it do
    { :post => '/freenode/ruby/logs/' }.
    should route_to :controller => 'logs', :action => 'create',
                    :network => 'freenode', :channel => 'ruby'
  end
end
