require 'spec_helper'

describe "LinkRoutes", type: :routing do
  it do
    expect({ :get => '/freenode/ruby/links/' }).to route_to(
      :controller => 'links', :action => 'index', :network => 'freenode', :channel => 'ruby'
    )
  end

  it do
    expect({ :get => '/freenode/ruby/links.rss' }).to route_to(
      :controller => 'links', :action => 'index', :format => 'rss', :network => 'freenode', :channel => 'ruby'
    )
  end

  it do
    expect({ :post => '/freenode/ruby/links/' }).to route_to(
      :controller => 'links', :action => 'create', :network => 'freenode', :channel => 'ruby'
    )
  end
end
