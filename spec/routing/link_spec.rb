require 'spec_helper'

describe "LinkRoutes" do
  it do
    { :get => '/freenode/ruby/links/' }.
    should route_to :controller => 'links', :action => 'index',
                    :network => 'freenode', :channel => 'ruby'
  end

  it do
    { :post => '/freenode/ruby/links/' }.
    should route_to :controller => 'links', :action => 'create',
                    :network => 'freenode', :channel => 'ruby'
  end
end
