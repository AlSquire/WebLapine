require 'spec_helper'

describe "LogRoutes", type: :routing do
  it do
    expect({ :get => '/freenode/ruby/logs/' }).to route_to(
      :controller => 'logs', :action => 'index', :network => 'freenode', :channel => 'ruby'
    )
  end

  it do
    expect({ :get => '/freenode/ruby/logs.rss' }).to route_to(
      :controller => 'logs', :action => 'index', :format => 'rss', :network => 'freenode', :channel => 'ruby'
    )
  end

  it do
    expect({ :get => '/freenode/ruby/logs/random.txt' }).to route_to(
      :controller => 'logs', :action => 'random', :format => 'txt', :network => 'freenode', :channel => 'ruby'
    )
  end

  it do
    expect({ :get => '/freenode/ruby/logs/search.txt' }).to route_to(
      :controller => 'logs', :action => 'search', :format => 'txt', :network => 'freenode', :channel => 'ruby'
    )
  end

  it do
    expect({ :get => '/freenode/ruby/logs/previous.txt' }).to route_to(
      :controller => 'logs', :action => 'previous', :format => 'txt', :network => 'freenode', :channel => 'ruby'
    )
  end

  it do
    expect({ :post => '/freenode/ruby/logs/' }).to route_to(
      :controller => 'logs', :action => 'create', :network => 'freenode', :channel => 'ruby'
    )
  end
end
