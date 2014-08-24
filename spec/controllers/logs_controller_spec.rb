require 'spec_helper'

describe LogsController do

  shared_examples 'an irc scoped action' do
    it do
      assigns(:network).should == 'freenode'
    end
    it do
      assigns(:channel).should == 'ruby'
    end
  end

  before do
    FactoryGirl.create(:log)
  end

  describe 'GET :index' do
    before do
      get :index, :network => 'freenode', :channel => 'ruby'
    end

    it_behaves_like 'an irc scoped action'

    it { should respond_with(:success) }
    it { assigns(:logs).should_not be_nil }
  end

  describe 'GET :index with search param' do
    before do
      Log.should_receive(:search_text).with('term').and_return(Log)
      get :index, :network => 'freenode', :channel => 'ruby', :search => 'term'
    end

    it_behaves_like 'an irc scoped action'

    it { should respond_with(:success) }
    it { assigns(:logs).should_not be_nil }
  end

  describe 'GET :index .rss' do
    before do
      get :index, :network => 'freenode', :channel => 'ruby', :format => :rss
    end

    it_behaves_like 'an irc scoped action'

    it { should respond_with(:success) }
    it { assigns(:logs).should_not be_nil }
  end

  describe 'POST :create' do
    before do
      post :create, :network => 'freenode', :channel => 'ruby',
           :log => { :sender => 'nick', :line => 'What is ruby 1.9.2?' }
    end

    it_behaves_like 'an irc scoped action'

    it { should respond_with(:success) }
    it do
      assigns(:log).should be_valid
      assigns(:log).should be_persisted
    end
  end

  describe 'GET :random .txt' do
    before do
      log = FactoryGirl.build_stubbed(:log)
      Log.should_receive(:random).and_return(log)
      get :random, :network => 'freenode', :channel => 'ruby', :format => :txt
    end

    it_behaves_like 'an irc scoped action'

    it { should respond_with(:success) }
    it { assigns(:log).should_not be_nil }
  end

  describe 'GET :search .txt' do
    before do
      FactoryGirl.create(:log, :line => 'search me')
      get :search, :network => 'freenode', :channel => 'ruby', :format => :txt,
          :term => 'search me'
    end

    it_behaves_like 'an irc scoped action'

    it { should respond_with(:success) }
    it { assigns(:log).should_not be_nil }
  end

  describe 'GET :previous .txt' do
    before do
      log = FactoryGirl.build_stubbed(:log)
      Log.should_receive(:previous).with(3).and_return(log)
      get :previous, :network => 'freenode', :channel => 'ruby', :format => :txt,
          :offset => "3"
    end

    it_behaves_like 'an irc scoped action'

    it { should respond_with(:success) }
    it { assigns(:log).should_not be_nil }
  end
end
