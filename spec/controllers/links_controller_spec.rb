require 'spec_helper'

describe LinksController do
  describe 'GET :index' do
    before do
      get :index, :network => 'freenode', :channel => 'ruby'
    end

    it { should respond_with(:success) }
    it do
      assigns(:network).should == 'freenode'
    end
    it do
      assigns(:channel).should == 'ruby'
    end
    it do
      assigns(:links).should_not be_nil
    end
  end

  describe 'GET :index with search param' do
    before do
      Link.should_receive(:search).with('term').and_return(Link)
      get :index, :network => 'freenode', :channel => 'ruby', :search => 'term'
    end

    it { should respond_with(:success) }
    it do
      assigns(:network).should == 'freenode'
    end
    it do
      assigns(:channel).should == 'ruby'
    end
    it do
      assigns(:links).should_not be_nil
    end
  end

  describe 'GET :index .rss' do
    before do
      get :index, :network => 'freenode', :channel => 'ruby', :format => :rss
    end

    it { should respond_with(:success) }
    it do
      assigns(:network).should == 'freenode'
    end
    it do
      assigns(:channel).should == 'ruby'
    end
    it do
      assigns(:links).should_not be_nil
    end
  end

  describe 'POST :create' do
    before do
      post :create, :network => 'freenode', :channel => 'ruby',
           :link => { :sender => 'nick', :line => 'Love this : http://ruby.fr' }
    end

    it { should respond_with(:success) }
    it do
      assigns(:link).should be_valid
      assigns(:link).should be_persisted
    end
  end
end
